using System.ComponentModel.DataAnnotations;

namespace ProductApi.Models;

public class Producto
{
    public int Id { get; set; }

    [Required]
    public string Sku { get; set; } = string.Empty;

    [Required]
    public string Name { get; set; } = string.Empty;
    
    [Range(0.01, double.MaxValue, ErrorMessage = "El precio debe ser mayor a 0")]
    public decimal Price { get; set; }

    public string Currency { get; set; } = "BOB";

    public int Stock { get; set; }
}