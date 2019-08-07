using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Model;
using System;
using System.Data.Common;
namespace MT.Repository
{
    /// <summary>
    /// Xử lý thông tin login
    /// </summary>
    /// Create by: dvthang:08.01.2018
    public class TokensRepository : BaseRepository<Tokens>, ITokensRepository
    {
        #region"Declare"
        
        #endregion
        #region"Contructor"
        public TokensRepository()
        {
        }

        public TokensRepository(SqlDatabase db,DbTransaction ts):base(db,ts)
        {

        }
        #endregion
        #region"Sub/Func"
        /// <summary>
        /// Kiem tra thong  tin dang nhap nhap con hieu luc khong
        /// </summary>
        /// <param name="tokenId">Token da luu</param>
        /// <returns>true: thanh cong, nguoc lai thats bai</returns>
        /// Create by: dvthang:12.1.2018
        public bool ValidateToken(string tokenId, ref Token oToken)
        {
            bool isSucces = false;

            Tokens tokens = this.GetDataByID(Guid.Parse(tokenId));
            if (tokens != null && tokens.ExpiresOn >= DateTime.Now)
            {
                isSucces = true;
                oToken = MT.Library.CommonFunction.DeserializeObject<Token>(tokens.Token);
            }
            return isSucces;
        }

        #endregion
    }
}
