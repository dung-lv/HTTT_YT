using System;
using System.ComponentModel.DataAnnotations;

namespace MT.Model
{
    public class Tokens:EntityBase
    {
        [Key]
        public Guid TokenId { get; set; }
        public string UserName { get; set; }
        public string Token { get; set; }
        public DateTime ExpiresOn { get; set; }
        public DateTime IssuedOn { get; set; }
    }
}
