using System.ComponentModel.DataAnnotations;

namespace ProductApi.Dtos;

public class ActualizarPrecioDto
{
    [Range(0.01, double.MaxValue, ErrorMessage = "El precio debe ser mayor a 0")]
    public decimal Price { get; set; }
}