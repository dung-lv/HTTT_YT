using MT.Model;
namespace MT.Repository
{
    public interface ITokensRepository : IBaseRepository<Tokens>
    {
        /// <summary>
        /// Kiem tra thong  tin dang nhap nhap con hieu luc khong
        /// </summary>
        /// <param name="tokenId">Token da luu</param>
        /// <returns>true: thanh cong, nguoc lai thats bai</returns>
        /// Create by: dvthang:12.1.2018
        bool ValidateToken(string tokenId, ref Token oToken);
    }
}
