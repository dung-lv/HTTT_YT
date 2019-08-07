var QLDT = QLDT || {};
QLDT.Config = QLDT.Config || {};
QLDT.Config = {
    apiBE: 'http://localhost:36191/api',
    constant: {
        Token: 'token',
        TokenID: 'TokenID',
        UserID: 'UserID',
        UserName: 'UserName',
        GroupID: 'GroupID',
        ReportYear: 'ReportYear'

    },
    setToken: function (token, tokenId, userID, UserName, GroupID, ReportYear) {
        var me = this;
        if (window.localStorage !== undefined) {
            if (token) {
                window.localStorage.removeItem(QLDT.Config.constant.Token);
                window.localStorage.removeItem(QLDT.Config.constant.TokenID);
                window.localStorage.removeItem(QLDT.Config.constant.UserName);
                window.localStorage.removeItem(QLDT.Config.constant.UserID, userID);
                window.localStorage.removeItem(QLDT.Config.constant.GroupID);
                window.localStorage.removeItem(QLDT.Config.constant.ReportYear);


                window.localStorage.setItem(QLDT.Config.constant.Token, token);
                window.localStorage.setItem(QLDT.Config.constant.TokenID, tokenId);
                window.localStorage.setItem(QLDT.Config.constant.UserID, userID);
                window.localStorage.setItem(QLDT.Config.constant.UserName, UserName);
                window.localStorage.setItem(QLDT.Config.constant.GroupID, GroupID);
                window.localStorage.setItem(QLDT.Config.constant.ReportYear, ReportYear);

            }
        } else {
            console.log('Your browser is outdated!');
        }
    },

    getUserID: function () {
        var me = this, userID = null;
        if (window.localStorage !== undefined) {
            userID = window.localStorage.getItem(QLDT.Config.constant.UserID);
        } else {
            console.log('Your browser is outdated!');
        }
        return userID;
    },

    getUserName: function () {
        var me = this, UserName = null;
        if (window.localStorage !== undefined) {
            UserName = window.localStorage.getItem(QLDT.Config.constant.UserName);
        } else {
            console.log('Your browser is outdated!');
        }
        return UserName;
    },

    getToken: function () {
        var me = this, token = null;
        if (window.localStorage !== undefined) {
            token = window.localStorage.getItem(QLDT.Config.constant.Token);
        } else {
            console.log('Your browser is outdated!');
        }
        return token;
    },

    getTokenID: function () {
        var me = this, tokenId = null;
        if (window.localStorage !== undefined) {
            tokenId = window.localStorage.getItem(QLDT.Config.constant.TokenID);
        } else {
            console.log('Your browser is outdated!');
        }
        return tokenId;
    },

    getReportYear: function () {
        var me = this, reportYear = null;
        if (window.localStorage !== undefined) {
            reportYear = window.localStorage.getItem(QLDT.Config.constant.ReportYear);
        } else {
            console.log('Your browser is outdated!');
        }
        return reportYear;
    },

    getGroupID: function () {
        var me = this, groupID = null;
        if (window.localStorage !== undefined) {
            groupID = window.localStorage.getItem(QLDT.Config.constant.GroupID);
        } else {
            console.log('Your browser is outdated!');
        }
        return groupID;
    }
}