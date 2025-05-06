// using Microsoft.AspNetCore.Mvc;
// using MyApiProject.Data;
// using MyApiProject.Models;

// namespace MyApiProject.Controllers
// {
//     // [Route("api/[controller]")]
//     // [ApiController]
//     public class ProductController : ControllerBase
//     {
//         private readonly AppDbContext _context;

//         public ProductController(AppDbContext context)
//         {
//             _context = context;
//         }

//         [HttpGet]
//         public IActionResult GetProducts()
//         {
//             var products = _context.Products.ToList();
//             return Ok(products);
//         }

//         [HttpPost]
//         public IActionResult AddProduct(Product product)
//         {
//             _context.Products.Add(product);
//             _context.SaveChanges();
//             return CreatedAtAction(nameof(GetProducts), new { id = product.Id }, product);
//         }
//     }
// }
