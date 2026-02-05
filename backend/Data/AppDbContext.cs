using Microsoft.EntityFrameworkCore;
using ProductApi.Models;

namespace ProductApi.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Producto> Products => Set<Producto>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Seed Data: Datos iniciales según el JSON de la prueba
        modelBuilder.Entity<Producto>().HasData(
            new Producto { Id = 1, Sku = "SKU-1001", Name = "Auriculares Bluetooth", Price = 199.90m, Currency = "BOB", Stock = 25 },
            new Producto { Id = 2, Sku = "SKU-1002", Name = "Monitor 24 IPS", Price = 1200.50m, Currency = "BOB", Stock = 10 },
            new Producto { Id = 3, Sku = "SKU-1003", Name = "Teclado Mecánico", Price = 350.00m, Currency = "BOB", Stock = 5 }
        );
    }
}