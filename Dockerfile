# Use the official Microsoft .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the csproj and restore as distinct layers
COPY ["HelloDocker/HelloDocker.csproj", "HelloDocker/"]
RUN dotnet restore "HelloDocker/HelloDocker.csproj"

# Copy the remaining source code and build the app
COPY HelloDocker/. HelloDocker/
WORKDIR "/src/HelloDocker"
RUN dotnet build "HelloDocker.csproj" -c Release -o /app/build

# Publish the app
RUN dotnet publish "HelloDocker.csproj" -c Release -o /app/publish

# Use the official Microsoft .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/runtime:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "HelloDocker.dll"]