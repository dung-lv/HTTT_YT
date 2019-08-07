using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MT.Resources;
namespace MT.Model
{
   public class User
    {
        [Required(ErrorMessageResourceName = "UserName_Blank", ErrorMessageResourceType =typeof(MT.Resources.GlobalResource))]
        [MaxLength(50)]
        public string UserName { get; set; }
        [Required(ErrorMessageResourceName = "Password_Blank", ErrorMessageResourceType = typeof(MT.Resources.GlobalResource))]
        public string Password { get; set; }
    }
}
