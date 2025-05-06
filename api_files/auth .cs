using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization; // Required for AllowAnonymous
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace MyFirstApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TokenController : ControllerBase
    {
        private readonly string _issuer;

        public TokenController()
        {
            _issuer = "Birla White IT"; // Issuer for the JWT
        }

        [HttpPost("generate")]
        [AllowAnonymous] // Bypass authentication for this endpoint
        public IActionResult GenerateToken([FromBody] TokenRequest request)
        {
            if (string.IsNullOrEmpty(request.PartnerID) || string.IsNullOrEmpty(request.SecretKey))
            {
                return BadRequest("PartnerID and SecretKey are required.");
            }

            try
            {
                var token = CreateJwtToken(request.PartnerID, request.SecretKey);

                return Ok(new { Token = token });
            }
            catch (Exception ex)
            {
                return StatusCode(
                    500,
                    $"An error occurred while generating the token: {ex.Message}"
                );
            }
        }

        private string CreateJwtToken(string partnerId, string secretKey)
        {
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim("PartnerID", partnerId), // Add PartnerID to claims
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()), // Unique token ID
                new Claim(JwtRegisteredClaimNames.Iss, _issuer), // Issuer claim
            };

            var token = new JwtSecurityToken(
                issuer: _issuer,
                claims: claims,
                expires: DateTime.UtcNow.AddHours(24), // Token valid for 24 hour
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }

    public class TokenRequest
    {
        public string PartnerID { get; set; }

        public string SecretKey { get; set; }
    }
}
