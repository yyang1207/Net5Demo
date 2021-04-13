#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["Net5Demo/Net5Demo.csproj", "Net5Demo/"]
RUN dotnet restore "Net5Demo/Net5Demo.csproj"
COPY . .
WORKDIR "/src/Net5Demo"
RUN dotnet build "Net5Demo.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Net5Demo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Net5Demo.dll"]