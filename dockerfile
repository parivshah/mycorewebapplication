FROM microsoft/aspnetcore:2.0 As base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 As build
#WORKDIR /src
Copy *.sln ./
Copy MyCoreWebApplication/MyCoreWebApplication.csproj MyCoreWebApplication/
RUN dotnet restore
Copy . .
WORKDIR /src/MyCoreWebApplication
RUN dotnet build -c release -o /app

FROM build As publish
RUN dotnet publish -c release -o /app

FROM base As final
WORKDIR /app
Copy --from=publish /app .
ENTRYPOINT ["dotnet","MyCoreWebApplication.dll"]