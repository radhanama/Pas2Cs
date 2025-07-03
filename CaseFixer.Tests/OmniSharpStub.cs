using System;
using System.IO;
using System.Net;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace CaseFixer.Tests;

internal sealed class OmniSharpStub : IDisposable
{
    private readonly HttpListener _listener = new();
    private readonly Task _loop;
    private readonly string _filePath;

    public OmniSharpStub(string filePath)
    {
        _filePath = filePath;
        _listener.Prefixes.Add("http://localhost:2000/");
        _listener.Start();
        _loop = Task.Run(LoopAsync);
    }

    private async Task LoopAsync()
    {
        while (_listener.IsListening)
        {
            var ctx = await _listener.GetContextAsync();
            if (ctx.Request.HttpMethod == "POST" && ctx.Request.Url.AbsolutePath == "/v2/gotoDefinition")
            {
                using var reader = new StreamReader(ctx.Request.InputStream);
                var body = await reader.ReadToEndAsync();
                var resp = new
                {
                    definitions = new[]
                    {
                        new
                        {
                            FileName = _filePath,
                            Range = new
                            {
                                Start = new { Line = 2, Column = 9 },
                                End = new { Line = 2, Column = 12 }
                            }
                        }
                    }
                };
                var json = JsonSerializer.Serialize(resp);
                var bytes = Encoding.UTF8.GetBytes(json);
                ctx.Response.StatusCode = 200;
                ctx.Response.ContentType = "application/json";
                await ctx.Response.OutputStream.WriteAsync(bytes, 0, bytes.Length);
                ctx.Response.Close();
            }
            else
            {
                ctx.Response.StatusCode = 404;
                ctx.Response.Close();
            }
        }
    }

    public void Dispose()
    {
        _listener.Stop();
        _listener.Close();
        try { _loop.Wait(1000); } catch { }
    }
}
