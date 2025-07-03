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
RUN apt-get update \
    && apt-get install -y python3 python3-pip \
    && pip3 install lark-parser \
    && chmod +x /tool/run_conversion.sh

WORKDIR /workspace
ENTRYPOINT ["/tool/run_conversion.sh"]
