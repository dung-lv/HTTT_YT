using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Mail;

namespace MT.Library
{
    /// <summary>
    /// Tất cả các tiện ích của email để vào hàm này
    /// </summary>
    /// Create by: dvthang:15.01.2017
    public class EmailUltility
    {
        public static string MailFrom = UtilityExtensions.GetKeyAppSetting(Commonkey.mscMailFrom);
        public static string PassMailFrom = UtilityExtensions.GetKeyAppSetting(Commonkey.mscPassMailFrom);
        public static string MailServer = UtilityExtensions.GetKeyAppSetting(Commonkey.mscMailServer);
        public static int PortMailServer = Convert.ToInt32(UtilityExtensions.GetKeyAppSetting(Commonkey.mscPortMailServer));

        /// <summary>
        /// Hàm gửi email
        /// </summary>
        /// <param name="CC">CC đến những ai</param>
        /// <param name="BCC"></param>
        /// <param name="Subject">Tiêu đề Email</param>
        /// <param name="Body">Nội dung email</param>
        /// <param name="attach">Gửi đính kèm</param>
        public static void SendMail(String CC, String BCC, String Subject, String Body, List<Attachment> lstFile)
        {

            //Lay dia chi basicCredential
            Char[] ch = { '@' };
            String[] tmp;
            String mailfrom;
            tmp = MailFrom.Split(ch);
            mailfrom = EmailUltility.MailFrom;// tmp[0]; - Cái này dùng với gmail
            //Co che chung thuc cua Mang
            NetworkCredential basicCredential = new NetworkCredential(mailfrom, EmailUltility.PassMailFrom);

            SmtpClient client = new SmtpClient(EmailUltility.MailServer, PortMailServer);
            MailMessage mail = new MailMessage();
            client.EnableSsl = true;
            client.UseDefaultCredentials = false;
            client.Credentials = basicCredential;
            //Mail Gửi
            mail.From = new MailAddress(MailFrom);

            //Gửi CC
            if (string.IsNullOrEmpty(CC) == false)
            {
                String[] c;
                c = CC.Split(',');
                if (c.Length > 1)
                {
                    for (int i = 0; i < c.Length; i++)
                    {
                        if (c[i] != "")
                        {
                            mail.CC.Add(new MailAddress(c[i]));
                        }
                    }
                }
                else
                {
                    mail.CC.Add(new MailAddress(CC));
                }
            }
            //Gửi BCC
            if (string.IsNullOrEmpty(BCC) == false)
            {
                String[] b;
                b = BCC.Split(',');
                if (b.Length > 1)
                {
                    for (int i = 0; i < b.Length; i++)
                    {
                        if (b[i] != "")
                        {
                            mail.Bcc.Add(new MailAddress(b[i]));
                        }
                    }
                }
                else
                {
                    mail.Bcc.Add(new MailAddress(BCC));
                }
            }
            if (lstFile != null)
            {
                foreach (Attachment attach in lstFile)
                {
                    mail.Attachments.Add(attach);
                }
            }
            mail.Subject = Subject;
            mail.Body = System.Web.HttpUtility.HtmlDecode(Body);
            mail.IsBodyHtml = true;
            mail.SubjectEncoding = System.Text.Encoding.UTF8;
            mail.BodyEncoding = System.Text.Encoding.UTF8;
            try
            {
                client.Send(mail);
            }
            catch (Exception ex)
            {
            }
        }
    }
}
