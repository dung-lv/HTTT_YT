namespace MT.Library
{
    public class Commonkey
    {
        public const string CreatedDate = "CreatedDate";
        public const string ModifiedDate = "ModifiedDate";
        public const string IPAddress = "IPAddress";
        public const string ModifiedBy = "ModifiedBy";
        public const string CreatedBy = "CreatedBy";

        #region"AppSettings"
        public const string mscMailFrom = "MailFrom";
        public const string mscPassMailFrom = "PassMailFrom";
        public const string mscMailServer = "MailServer";
        public const string mscPortMailServer = "PortMailServer";
        public const string mscMailTo = "MailTo";
        public const string mscUriLogin = "UriLogin";
        #endregion

        #region"Key CRUD"
        public const string mscSelectPaging = "{0}.Proc_Select{1}Paging";
        public const string mscInsert = "{0}.Proc_Insert{1}";
        public const string mscUpdate = "{0}.Proc_Update{1}";
        public const string mscDeleteByID = "{0}.Proc_Delete{1}ByID";
        public const string mscInsertUpdate = "{0}.Proc_InsertUpdate{1}";
        public const string mscSelectByID = "{0}.Proc_Select{1}ByID";
        public const string mscSelectByMasterID = "{0}.Proc_Select{1}ByMasterID";
        public const string mscSelectAll = "{0}.Proc_Select{1}All";
        public const string mscSelectAllByEditMode = "{0}.Proc_Select{1}AllByEditMode";
        /// <summary>
        /// Schema của DB
        /// </summary>
        /// Create by: dvthang:20.04.2017
        public const string Schema = "dbo";
        #endregion

        #region"Key User"
        public const string mscInvalid_grant = "invalid_grant";
        public const string mscUnsupported_grant_type = "unsupported_grant_type";

        public const string mscResponeLogin = "ResponeLogin";
        #endregion

        #region"Appsettings"
        public const string Domains = "qldt.domains";
        public const string AllowMethods = "qldt.allowmethods";
        public const string AllowHeaders = "qldt.allowheaders";
        #endregion
        #region"Login"
        public const string TokenLogin = "TokenLogin";
        #endregion

        #region"Upload"
        public const string Temp = "qldt.uploadfiletemp";
        public const string Upload = "qldt.uploadfileread";
        public const string UploadImg = "qldt.imgemployee";
        public const string Email = "qldt.email";
        public const string ProjectServey = "ProjectServey";
        public const string Template = "Template";
        public const string ProjectExperiment = "ProjectExperiment";
        #endregion
        #region"Auth"
        public const string Authorization = "Authorization";
        public const string TokenID = "TokenID";
        #endregion

        #region"Download"
        public const string DF = "DF";
        #endregion

        #region"KeyCache"
        public const string Capcha = "Capcha";
        public const string KeyActive = "KeyActive";
        #endregion

        #region"Header"
        public const string PositionID = "PositionID";
        public const string CompanyID = "CompanyID";
        public const string EmployeeID = "EmployeeID";
        public const string UserName = "UserName";
        #endregion

        #region "Phân quyền theo đơn vị + Chức vụ"
        //CreatedBy: laipv.24.02.2017
        //Nhóm đơn vị
        public const string Company_TTV_B = "65ad4561-b9ae-47c0-ba7d-56923a6c07f8"; // Thủ trưởng viện - Phía Bắc
        public const string Company_TTV_N = "2da02dea-57de-44a6-bf28-6f6ecabe15b3"; // Thủ trưởng viện - Phía Nam
        public const string Company_BKH = "660a1800-3e4a-49a4-bf7e-524907a7c375";   // Ban Kế hoạch
        public const string Company_BCT = "0acac66d-2d91-46a3-bc8f-76b63d9373fe";   // Ban Chính trị
        public const string Company_BHCHC = "f49aafba-f924-4a1c-af45-d7413bf523e3"; // Ban Hành chính Hậu cần
        public const string Company_BTC = "9c88eabb-0690-476f-aca8-d9fa37010e47";   // Ban Tài chính
        //Nhóm chức vụ
        public const string Position_VT = "fa647217-e2e3-4cd5-b03e-1841e0c582dc";   // Viện trưởng
        public const string Position_PVT = "9e9481ce-d125-4782-ab70-72646281295c";  // Phó Viện trưởng
        public const string Position_TP = "1a2d37fe-6bd7-4369-9d7f-c5b07dd55c45";   // Trưởng Phòng
        public const string Position_PTP = "b6e92456-1020-4e61-aadd-6052f8effec6";  // Phó Trưởng phòng
        #endregion

        #region"ExportExcell"
        public const string Excel = "~/Data/Template";
        #endregion
    }
}
