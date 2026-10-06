using Vite.AspNetCore;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

builder.CreateUmbracoBuilder()
    .AddBackOffice()
    .AddWebsite()
    .AddComposers()
    .Build();

builder.Services.AddViteServices(options =>
{
    options.Manifest = ".vite/manifest.json";
    options.Base = builder.Environment.IsDevelopment() ? string.Empty : "dist";
    options.Server.PackageDirectory = "ClientApp";
    // Must match server.port in ClientApp/vite.config.ts (5174, so this site can run next to AiPoc)
    options.Server.Port = 5174;
    options.Server.AutoRun = true;
});

WebApplication app = builder.Build();

await app.BootUmbracoAsync();

if (app.Environment.IsDevelopment())
{
    app.UseViteDevelopmentServer(true);
}


app.UseUmbraco()
    .WithMiddleware(u =>
    {
        u.UseBackOffice();
        u.UseWebsite();
    })
    .WithEndpoints(u =>
    {
        u.UseBackOfficeEndpoints();
        u.UseWebsiteEndpoints();
    });

await app.RunAsync();
