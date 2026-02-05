using Microsoft.EntityFrameworkCore;
using ProductApi.Data;
using ProductApi.Dtos;
using ProductApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(opt =>
    opt.UseInMemoryDatabase("ProductDb"));

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy => policy.AllowAnyOrigin()
                        .AllowAnyMethod()
                        .AllowAnyHeader());
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.EnsureCreated();
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();

app.MapGet("/products", async (AppDbContext db, string? search, string? sort, bool? onlyAvailable, int page = 1, int pageSize = 15) =>
{
    var query = db.Products.AsQueryable();
    if (!string.IsNullOrWhiteSpace(search))
    {
        var term = search.ToLower();
        query = query.Where(p => p.Name.ToLower().Contains(term)
                              || p.Sku.ToLower().Contains(term));
    }
    if (onlyAvailable == true)
    {
        query = query.Where(p => p.Stock > 0);
    }

    query = sort switch
    {
        "price_asc" => query.OrderBy(p => p.Price),
        "price_desc" => query.OrderByDescending(p => p.Price),
        _ => query
    };
    return await query.ToListAsync();

    var products = await query
        .Skip((page - 1) * pageSize)
        .Take(pageSize)
        .ToListAsync();

    return products;
})
.WithName("GetProducts")
.WithOpenApi();

app.MapPatch("/products/{id}", async (int id, ActualizarPrecioDto dto, AppDbContext db) =>
{
    if (dto.Price <= 0)
        return Results.BadRequest(new { message = "El precio debe ser mayor a 0" });
    var product = await db.Products.FindAsync(id);
    if (product is null)
        return Results.NotFound(new { message = "Producto no encontrado" });
    product.Price = dto.Price;
    await db.SaveChangesAsync();
    return Results.Ok(product);
})
.WithName("UpdateProductPrice")
.WithOpenApi();

app.Run();