using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MT.Model
{
    public static class Constant
    {
        //Mỗi lần chỉ cho upload file có dung lượng tối data 5MB
        public const float mscMaxFileUpload = 5;
        //Các file cho không cho phép upload
        public const string mscNotAllowExtention = ".exe,.dll";
    }
}
