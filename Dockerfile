# Use official .NET 9 SDK image
FROM mcr.microsoft.com/dotnet/sdk:9.0-preview AS build
WORKDIR /app

# Copy csproj and restore
COPY *.csproj ./
RUN dotnet restore

# Copy the rest and publish
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0-preview
WORKDIR /app
COPY --from=build /app/out .

# Set environment port (Render uses this)
ENV ASPNETCORE_URLS=http://+:$PORT

ENTRYPOINT ["dotnet", "AStarAlgorithmDemo.dll"]
