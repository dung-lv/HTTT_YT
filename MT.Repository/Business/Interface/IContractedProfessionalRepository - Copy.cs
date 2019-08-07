using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using MT.Library;
using MT.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
namespace MT.Repository
{
    public interface IContractedProfessionalRepository : IBaseRepository<ContractedProfessional>
    {
        /// <summary>
        /// Lấy về danh sách thue khoán chuyên môn
        /// </summary>
        /// <param name="projectID">mã đề tài</param>
        /// <returns></returns>
        List<ContractedProfessional> GetListContractedProfessional(Guid? projectID);
    }
}
