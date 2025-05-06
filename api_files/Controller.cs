using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using SPARSH_MOB.DataAccess;

namespace sparshWebService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class TokenScanController : ControllerBase
    {
        private readonly DatabaseHelper _dbHelper;

        public TokenScanController(DatabaseHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        [AllowAnonymous]
        [HttpPost("scan")]
        public IActionResult ExecuteStoredProcedure([FromBody] TokenRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.tokenNum))
            {
                return BadRequest("Parameter 'userID' and 'password' is required.");
            }
            try
            {
                var query =
                    "select a.tokenIdn from dptToknTranDtl a with (nolock) ,"
                    + "LY_dpmTokenNos b with (nolock) "
                    + "where a.tokenIdn = b.tokenIdn and isActive = 'X' "
                    + "and b.tokenNum = @tokenNum";
                var parameters = new Dictionary<string, object>
                {
                    { "@tokenNum", request.tokenNum },
                };
                var result = _dbHelper.WebSessBean(query, parameters);
                if (result == null || result.Count == 0)
                {
                    // Console.WriteLine(" No user found with userID: " + request.userID);
                    return Unauthorized("Invalid Token.");
                }
                string? TokenIdn = result[0]["tokenIdn"]?.ToString();
                return StatusCode(200, $"success");
            }
            catch (Exception ex)
            {
                //Console.WriteLine(" Exception: " + ex.Message);
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }

    public class TokenRequest
    {
        public string? tokenNum { get; set; }
    }
}
