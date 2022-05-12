#STAGE01 - Build app and its dependencies
FROM microsoft/dotnet:2.1-sdk AS build-env
WORKDIR /app

COPY webapp/*.csproj ./
COPY . ./
RUN dotnet restore 

# STAGE02 - Publish the app
FROM build-env AS publish
RUN dotnet publish -c Release -o /app

# STAGE03 - Create the final image
FROM microsoft/dotnet:2.1-aspnetcore-runtime-bionic
WORKDIR /app
LABEL Author="Najib Radzuan"
LABEL Maintainer="devops4me"
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebApp.dll", "--server.urls", "http://*:80"]
