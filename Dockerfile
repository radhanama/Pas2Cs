# Convert Oxygene projects to C#
# Usage:
#   docker run --rm -v $(pwd):/workspace pas2cs-convert

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY CaseFixer.csproj CaseFixer.csproj
COPY CaseFixer.cs CaseFixer.cs
RUN dotnet publish CaseFixer.csproj -c Release -o /casefixer

FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /tool
COPY . /tool
COPY --from=build /casefixer /tool/casefixer

# install the runtime dependencies OmniSharp needs:
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      libuv1 \
      libssl3 \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# download & extract the official OmniSharp Linux tarball
RUN mkdir -p /usr/local/omnisharp \
 && curl -sSL \
      https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.39.13/omnisharp-linux-x64-net6.0.tar.gz \
    | tar xz -C /usr/local/omnisharp \
 && ln -sf /usr/local/omnisharp/OmniSharp /usr/local/bin/omnisharp \
 && chmod +x /tool/run_conversion.sh

RUN apt-get update \
    && apt-get install -y python3 python3-pip \
    && pip3 install --break-system-packages lark-parser \
    && chmod +x /tool/run_conversion.sh

WORKDIR /workspace
ENTRYPOINT ["/tool/run_conversion.sh"]
