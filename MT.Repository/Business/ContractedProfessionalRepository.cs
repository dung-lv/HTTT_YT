using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
namespace MT.Repository
{
    /// <summary>
    /// Bảng chấm công (kinh phí) thực hiện đề tài
    /// </summary>
    /// Create by: laipv:03.03.2018
    public class ContractedProfessionalRepository : BaseRepository<ContractedProfessional>, IContractedProfessionalRepository
    {
        #region"Contructor"
        public ContractedProfessionalRepository()
        {

        }
        public ContractedProfessionalRepository(SqlDatabase db, DbTransaction ts) : base(db, ts)
        {

        }
        #endregion
        #region"Sub/Function"
        /// <summary>
        /// Lấy về danh sách thue khoán chuyên môn
        /// </summary>
        /// <param name="projectID">mã đề tài</param>
        /// <returns></returns>
        public List<ContractedProfessional> GetListContractedProfessional(Guid? projectID)
        {
            return this.ExecuteReader<ContractedProfessional>("[dbo].[Proc_GetListContractedProfessional_By_ProjectID]", projectID);
        }
        #endregion
    }
}
