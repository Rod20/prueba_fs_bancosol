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
            new Producto { Id = 1, Sku = "1001", Name = "Auriculares Bluetooth", Price = 199.90m, Currency = "BOB", Stock = 25 },
            new Producto { Id = 2, Sku = "1002", Name = "Monitor 24 IPS", Price = 1200.50m, Currency = "BOB", Stock = 10 },
            new Producto { Id = 3, Sku = "1003", Name = "Teclado Mecánico", Price = 350.00m, Currency = "BOB", Stock = 5 },
            new Producto { Id = 4, Sku = "1004", Name = "Mouse Gamer Cougar", Price = 250.00m, Currency = "BOB", Stock = 15 },
            new Producto { Id = 5, Sku = "1005", Name = "Laptop Gamer VENTUS", Price = 8500.00m, Currency = "BOB", Stock = 3 },
            new Producto { Id = 6, Sku = "1006", Name = "Silla Ergonómica D-RACER", Price = 1500.00m, Currency = "BOB", Stock = 0 },
            new Producto { Id = 7, Sku = "1007", Name = "WEBCAM", Price = 420.00m, Currency = "BOB", Stock = 20 },
            new Producto { Id = 8, Sku = "1008", Name = "Disco SSD KINGSTON", Price = 650.00m, Currency = "BOB", Stock = 12 },
            new Producto { Id = 9, Sku = "1009", Name = "Memoria RAM 16GB Crucial", Price = 550.00m, Currency = "BOB", Stock = 8 },
            new Producto { Id = 10, Sku = "1010", Name = "Parlantes DJV", Price = 120.00m, Currency = "BOB", Stock = 30 },
            new Producto { Id = 11, Sku = "1011", Name = "Mochila Xiaomi Antirrobo", Price = 200.00m, Currency = "BOB", Stock = 50 },
            new Producto { Id = 12, Sku = "1012", Name = "iPad Pro 13\"", Price = 1800.00m, Currency = "BOB", Stock = 0 },
            new Producto { Id = 13, Sku = "1013", Name = "PowerBank 20000", Price = 150.00m, Currency = "BOB", Stock = 22 },
            new Producto { Id = 14, Sku = "1014", Name = "Cable HDMI 2m", Price = 40.00m, Currency = "BOB", Stock = 100 },
            new Producto { Id = 15, Sku = "1015", Name = "Mousepad One Piece", Price = 90.00m, Currency = "BOB", Stock = 40 },
            new Producto { Id = 16, Sku = "1016", Name = "Micrófono USB RedDragon", Price = 750.00m, Currency = "BOB", Stock = 7 },
            new Producto { Id = 17, Sku = "1017", Name = "Soporte para Monitor", Price = 300.00m, Currency = "BOB", Stock = 14 },
            new Producto { Id = 18, Sku = "1018", Name = "Router WiFi 6", Price = 900.00m, Currency = "BOB", Stock = 6 },
            new Producto { Id = 19, Sku = "1019", Name = "Impresora CANON", Price = 2200.00m, Currency = "BOB", Stock = 0 },
            new Producto { Id = 20, Sku = "1020", Name = "Apple Watcj", Price = 1100.00m, Currency = "BOB", Stock = 18 },
            new Producto { Id = 21, Sku = "1021", Name = "Funda Laptop 15\"", Price = 80.00m, Currency = "BOB", Stock = 35 },
            new Producto { Id = 22, Sku = "1022", Name = "Hub USB-C UGREEN", Price = 280.00m, Currency = "BOB", Stock = 9 },
            new Producto { Id = 23, Sku = "1023", Name = "Cámara Seguridad Tomate", Price = 500.00m, Currency = "BOB", Stock = 11 }
        );
    }
}