FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["nodockerweb/nodockerweb.csproj", "nodockerweb/"]
RUN dotnet restore "nodockerweb/nodockerweb.csproj"
COPY . .
WORKDIR "/src/nodockerweb"
RUN dotnet build "nodockerweb.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "nodockerweb.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "nodockerweb.dll"]