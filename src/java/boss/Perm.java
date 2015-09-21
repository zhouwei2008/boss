package boss;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: leizhen
 * Date: 11-12-13
 * Time: 下午3:07
 */
public enum Perm {
  ROOT("BOSS", null),
    Bank("银行管理", ROOT),
      Bank_Manage("银行管理", Bank),
        Bank_Manage_New("创建", Bank_Manage),
        Bank_Manage_View("查看", Bank_Manage),
          Bank_Manage_Edit("编辑", Bank_Manage_View),
	      Bank_Manage_Delete("删除", Bank_Manage_View),
      Bank_Issu("收单银行账户管理", Bank),
        Bank_Issu_New("创建", Bank_Issu),
        Bank_Issu_View("查看", Bank_Issu),
          Bank_Issu_Edit("编辑", Bank_Issu_View),
	      Bank_Issu_Delete("删除", Bank_Issu_View),
        Bank_Issu_Merc("设置收单商户", Bank_Issu),
          Bank_Issu_Merc_New("创建", Bank_Issu_Merc),
          Bank_Issu_Merc_View("查看", Bank_Issu_Merc),
            Bank_Issu_Merc_Edit("编辑", Bank_Issu_Merc_View),
	        Bank_Issu_Merc_Delete("删除", Bank_Issu_Merc_View),
           Bank_Issu_Merc_Channel("渠道管理", Bank_Issu_Merc),
              Bank_Issu_Merc_Channel_New("创建", Bank_Issu_Merc_Channel),
              Bank_Issu_Merc_Channel_View("查看", Bank_Issu_Merc_Channel),
                Bank_Issu_Merc_Channel_Edit("编辑", Bank_Issu_Merc_Channel_View),

      Bank_Charge("银行账户充值", Bank),
      Bank_WithDraw("银行账户提款", Bank),
      Bank_Trans("银行账户转账", Bank),
      Bank_TransChk("银行充提转审核", Bank),
        Bank_TransChk_View("查看", Bank_TransChk),
        Bank_TransChk_Pass("审核", Bank_TransChk),
        Bank_TransChk_Ref("拒绝", Bank_TransChk),
      Bank_TransRec("银行充提转记录", Bank),
	    Bank_RouteSet("渠道路由管理", Bank),
        Bank_TransRec_View("查看", Bank_TransRec),
    Cust("客户管理", ROOT),
      Cust_Corp("企业客户管理", Cust),
        Cust_Corp_New("创建", Cust_Corp),
        Cust_Corp_Dl("下载", Cust_Corp),
        Cust_Corp_View("查看", Cust_Corp),
          Cust_Corp_Edit("编辑", Cust_Corp_View),
        Cust_Corp_Bank("银行账户", Cust_Corp),
          Cust_Corp_Bank_New("创建银行账户", Cust_Corp_Bank),
          Cust_Corp_Bank_Default("设为默认", Cust_Corp_Bank),
          Cust_Corp_Bank_View("查看", Cust_Corp_Bank),
            Cust_Corp_Bank_Edit("编辑", Cust_Corp_Bank_View),
               Real_Name_Authentication_View("查看实名认证照片",Cust_Corp_Bank_Edit),
               Real_Name_Authentication_Review("审核实名认证照片",Cust_Corp_Bank_Edit),

        Cust_Corp_Srv("服务管理", Cust_Corp),
          Cust_Corp_Srv_New("创建客户服务", Cust_Corp_Srv),
          Cust_Corp_Srv_BankSet("设置大额通道", Cust_Corp_Srv),
          Cust_Corp_Srv_RfdSet("设置退款模式", Cust_Corp_Srv),
          Cust_Corp_Srv_PaySet("设置支付模式", Cust_Corp_Srv),
          Cust_Corp_Srv_SerSet("设置服务模式", Cust_Corp_Srv),
          Cust_Corp_Srv_ParamSet("服务参数管理", Cust_Corp_Srv),
          Cust_Corp_Srv_View("查看", Cust_Corp_Srv),
            Cust_Corp_Srv_Edit("编辑", Cust_Corp_Srv_View),

        Cust_Corp_DirectBind("定向支付绑定", Cust_Corp),
          Cust_Corp_DirectBind_New("创建定向支付绑定", Cust_Corp_DirectBind),
          Cust_Corp_DirectBind_Edit("编辑", Cust_Corp_DirectBind),
          Cust_Corp_DirectBind_View("查看", Cust_Corp_DirectBind),

        Cust_Corp_Op("操作员管理", Cust_Corp),
      Cust_Per("个人客户管理", Cust),
        Cust_Per_New("创建", Cust_Per),
        Cust_Per_Dl("下载", Cust_Per),
        Cust_Per_View("查看", Cust_Per),
          Cust_Per_Edit("编辑", Cust_Per_View),
        Cust_Per_Bank("银行账户", Cust_Per),
          Cust_Per_Bank_New("创建银行账户", Cust_Per_Bank),
          Cust_Per_Bank_Default("设为默认", Cust_Per_Bank),
          Cust_Per_Bank_View("查看", Cust_Per_Bank),
            Cust_Per_Bank_Edit("编辑", Cust_Per_Bank_View),
        Cust_Per_Srv("服务管理", Cust_Per),
          Cust_Per_Srv_New("创建客户服务", Cust_Per_Srv),
          Cust_Per_Srv_BankSet("设置大额通道", Cust_Per_Srv),
          Cust_Per_Srv_RfdSet("设置退款模式", Cust_Per_Srv),
          Cust_Per_Srv_PaySet("设置支付模式", Cust_Per_Srv),
          Cust_Per_Srv_ParamSet("服务参数管理", Cust_Per_Srv),
          Cust_Per_Srv_View("查看", Cust_Per_Srv),
            Cust_Per_Srv_Edit("编辑", Cust_Per_Srv_View),

        Trade_BranchQry("分公司相关交易查询", Cust),
        Trade_BranchQry_Dl("下载", Trade_BranchQry),
        Trade_BranchQry_View("查看", Trade_BranchQry),
        Trade_BranchQry_Relate("相关交易", Trade_BranchQry),

        Trade_SaleQry("销售客户相关在线支付交易查询", Cust),
        Trade_SaleQry_Dl("下载", Trade_SaleQry),
        Trade_SaleQry_View("查看", Trade_SaleQry),
        Trade_SaleQry_Relate("相关交易", Trade_SaleQry),

      Cust_Application("在线申请客户管理", Cust),
        Cust_Application_Dl("下载", Cust_Application),
        Cust_Application_View("查看", Cust_Application),
        Cust_Application_Del("删除", Cust_Application),
        Cust_Application_New("新建客户", Cust_Application),

    WithDraw("客户结算管理", ROOT),
      WithDraw_Wait("待处理提现请求", WithDraw),
        WithDraw_Wait_Dl("下载", WithDraw_Wait),
        WithDraw_Wait_ProcBatPas("批量通过", WithDraw_Wait),
        WithDraw_Wait_ProcSigPas("单笔通过", WithDraw_Wait),
        WithDraw_Wait_ViewLs("交易流水查看", WithDraw_Wait),
            WithDraw_Wait_ProcPas("通过", WithDraw_Wait_ViewLs),
            WithDraw_Wait_ProcRef("拒绝", WithDraw_Wait_ViewLs),
      WithDraw_Chk("单笔提现审批", WithDraw),
        WithDraw_Chk_Dl("下载", WithDraw_Chk),
        WithDraw_Chk_ProcBatPas("批量通过", WithDraw_Chk),
        WithDraw_Chk_ViewLs("交易流水查看", WithDraw_Chk),
            WithDraw_Chk_ProcPas("通过", WithDraw_Chk_ViewLs),
            WithDraw_Chk_ProcRef("拒绝", WithDraw_Chk_ViewLs),
      WithDraw_ChkBth("批量提现审批", WithDraw),
        WithDraw_ChkBth_Dl("下载", WithDraw_ChkBth),
        WithDraw_ChkBth_View("详情", WithDraw_ChkBth),
            WithDraw_ChkBth_ProcRef("拒绝", WithDraw_ChkBth_View),
            WithDraw_ChkBth_ProcPas("通过", WithDraw_ChkBth_View),
            WithDraw_ChkBth_ProcDl("下载", WithDraw_ChkBth_View),
            WithDraw_ChkBth_ProcView("交易流水查看", WithDraw_ChkBth_View),
      WithDraw_RfdBthChk("提现处理", WithDraw),
        WithDraw_RfdBthChk_Dl("下载", WithDraw_RfdBthChk),
        WithDraw_RfdBthChk_ProcRef("拒绝", WithDraw_RfdBthChk),
        WithDraw_RfdBthChk_ProcPas("审批通过", WithDraw_RfdBthChk),
        WithDraw_RfdBthChk_ViewLs("交易流水查看", WithDraw_RfdBthChk),
        WithDraw_RfdBthChk_ViewBat("批次查看", WithDraw_RfdBthChk),
                WithDraw_RfdBthChk_BatNo("批次查看", WithDraw_RfdBthChk_ViewBat),
                WithDraw_RfdBthChk_TradeNo("交易流水查看", WithDraw_RfdBthChk_ViewBat),
                WithDraw_RfdBthChk_AutoChk("自动对账", WithDraw_RfdBthChk_ViewBat),
                    WithDraw_RfdBthChk_AutoChkUp("上传", WithDraw_RfdBthChk_AutoChk),
      WithDraw_RfdBthRef("提现复核", WithDraw),
        WithDraw_RfdBthRef_Dl("下载", WithDraw_RfdBthRef),
        WithDraw_RfdBthRef_ProcPas("复核通过", WithDraw_RfdBthRef),
        WithDraw_RfdBthRef_ProcRef("复核拒绝", WithDraw_RfdBthRef),
        WithDraw_RfdBthRef_ViewLs("交易流水查看", WithDraw_RfdBthRef),
        WithDraw_RfdBthRef_ViewBat("批次查看", WithDraw_RfdBthRef),
            WithDraw_RfdBthRef_BatNo("批次查看", WithDraw_RfdBthRef_ViewBat),
            WithDraw_RfdBthRef_TradeNo("交易流水查看", WithDraw_RfdBthRef_ViewBat),
      WithDraw_His("提现历史查询", WithDraw),
        WithDraw_His_ViewLs("交易流水查看", WithDraw_His),
        WithDraw_His_Dl("下载", WithDraw_His),
        WithDraw_His_ViewBat("批次查看", WithDraw_His),
            WithDraw_His_BatNo("批次查看", WithDraw_His_ViewBat),
            WithDraw_His_TradeNo("交易流水查看", WithDraw_His_ViewBat),
      WithDraw_InV_Init("发票初始化信息", WithDraw),
        WithDraw_InV_InitSave("保存", WithDraw_InV_Init),
        WithDraw_InV_InitStart("启用", WithDraw_InV_Init),
      WithDraw_InV_Osd("待开发票信息", WithDraw),
        WithDraw_InV_Create("生成发票", WithDraw_InV_Osd),
        WithDraw_InV_CreateAndDoenload("生成并下载", WithDraw_InV_Osd),
        WithDraw_InV_Adjust("调整金额", WithDraw_InV_Osd),
     WithDraw_InV_Info("发票信息查询", WithDraw),
        WithDraw_InV_Download01("下载发票", WithDraw_InV_Info),
        WithDraw_InV_Detail01("明细信息", WithDraw_InV_Info),
     WithDraw_InV_Entering("发票信息录入", WithDraw),
        WithDraw_InV_Download02("下载发票", WithDraw_InV_Entering),
        WithDraw_InV_Detail02("明细信息", WithDraw_InV_Entering),
        WithDraw_InV_EnterSave("保存", WithDraw_InV_Entering),
     WithDraw_InV_Expressing("快递信息录入", WithDraw),
        WithDraw_InV_Download03("下载发票", WithDraw_InV_Expressing),
        WithDraw_InV_Detail03("明细信息", WithDraw_InV_Expressing),
        WithDraw_InV_ExpressSave("保存", WithDraw_InV_Expressing),
     WithDraw_InV_Canceling("发票退回", WithDraw),
        WithDraw_InV_Download04("下载发票", WithDraw_InV_Canceling),
        WithDraw_InV_Detail04("明细信息", WithDraw_InV_Canceling),
        WithDraw_InV_CancelSave("发票退回", WithDraw_InV_Canceling),
    Account("客户账户管理", ROOT),
      Account_Acc("账户查询", Account),
        Account_Acc_View("查看", Account_Acc),
      Account_Bill("账务流水查询", Account),
        Account_Bill_View("查看", Account_Bill),
        Account_Bill_Dl("下载", Account_Bill),
      Account_Trans("账户调账", Account),
      Account_TransChk("账户调账审核", Account),
        Account_TransChk_Dl("下载", Account_TransChk),
        Account_TransChk_View("查看", Account_TransChk),
          Account_TransChk_Proc("处理", Account_TransChk_View),
    Gworder("网关订单及支付管理", ROOT),
      Gworder_Qry("网关订单查询", Gworder),
        Gworder_Qry_Dl("下载", Gworder_Qry),
        Gworder_Qry_View("查看", Gworder_Qry),
      Gworder_Trans("网关支付管理", Gworder),
        Gworder_Trans_View("查看", Gworder_Trans),
        Gworder_Trans_Dl("下载", Gworder_Trans),
        Gworder_Trans_Auto("自动核对", Gworder_Trans),
        Gworder_Trans_Succ("改成功", Gworder_Trans),
        Gworder_Trans_Fail("改失败", Gworder_Trans),
      Gworder_ExcpChk("异常订单审核", Gworder),
        Gworder_ExcpChk_DL("下载", Gworder_ExcpChk),
        Gworder_ExcpChk_View("查看", Gworder_ExcpChk),
        Gworder_ExcpChk_Proc("审核", Gworder_ExcpChk),
      Gworder_ExcpQry("异常订单查询", Gworder),
        Gworder_ExcpQry_Dl("下载", Gworder_ExcpQry),
        Gworder_ExcpQry_View("查看", Gworder_ExcpQry),
      Gworder_Sync("交易对账", Gworder),
        Gworder_Sync_UpLoad("上传", Gworder_Sync),
        Gworder_Sync_DownLoad("下载", Gworder_Sync),
        Gworder_Sync_Export("文件导出", Gworder_Sync),
        Gworder_Sync_View("查看", Gworder_Sync),

        Gworder_AccountTrade("批量对账", Gworder),
        Gworder_AccountTrade_UpLoad("上传", Gworder_AccountTrade),
        Gworder_AccountTrade_DownLoad("下载", Gworder_AccountTrade),
        Gworder_AccountTrade_Detail_View("明细查看", Gworder_AccountTrade),
        Gworder_AccountTrade_Detail_DownLoad("明细下载", Gworder_AccountTrade_Detail_View),
        Gworder_AccountTrade_Detail_Remarks_New("添加备注", Gworder_AccountTrade_Detail_View),
        Gworder_AccountTrade_Detail_Remarks_View("查看备注", Gworder_AccountTrade_Detail_View),
        Gworder_AccountTrade_Detail_Remarks_Edit("编辑备注", Gworder_AccountTrade_Detail_Remarks_View),
        Gworder_AccountTrade_Detail_Remarks_Del("删除备注", Gworder_AccountTrade_Detail_Remarks_View),

      Gworder_Mobile("手机订单查询", Gworder),



    Trade("交易管理", ROOT),
      Trade_Qry("交易查询", Trade),
        Trade_Qry_Dl("下载", Trade_Qry),
        Trade_Qry_View("查看", Trade_Qry),
        Trade_Qry_Relate("相关交易", Trade_Qry),
      Trade_RfdWait("待处理退款请求", Trade),
        Trade_RfdWait_Dl("下载", Trade_RfdWait),
        Trade_RfdWait_ProcBatPas("批量通过", Trade_RfdWait),
        Trade_RfdWait_ProcSigPas("单笔通过", Trade_RfdWait),
        Trade_RfdWait_ViewBankNo("银行订单查看", Trade_RfdWait),
//            Trade_RfdWait_ViewGwNo("网关订单查看", Trade_RfdWait_ViewBankNo),
        Trade_RfdWait_ViewLs("交易流水查看", Trade_RfdWait),
            Trade_RfdWait_ProcPas("通过", Trade_RfdWait_ViewLs),
            Trade_RfdWait_ProcRef("拒绝", Trade_RfdWait_ViewLs),
      Trade_RfdChk("单笔退款审批", Trade),
        Trade_RfdChk_Dl("下载", Trade_RfdChk),
        Trade_RfdChk_ProcBatPas("批量通过", Trade_RfdChk),
        Trade_RfdChk_ViewBankNo("银行订单查看", Trade_RfdChk),
//            Trade_RfdChk_ViewGwNo("网关订单查看", Trade_RfdChk_ViewBankNo),
        Trade_RfdChk_ViewLs("交易流水查看", Trade_RfdChk),
            Trade_RfdChk_ProcPas("通过", Trade_RfdChk_ViewLs),
            Trade_RfdChk_ProcRef("拒绝", Trade_RfdChk_ViewLs),
      Trade_RfdBthChk("批量退款审批", Trade),
        Trade_RfdBthChk_Dl("下载", Trade_RfdBthChk),
        Trade_RfdBthChk_View("详情", Trade_RfdBthChk),
            Trade_RfdBthChk_ProcPas("通过", Trade_RfdBthChk_View),
            Trade_RfdBthChk_ProcRef("拒绝", Trade_RfdBthChk_View),
            Trade_RfdBthChk_ProcDl("下载", Trade_RfdBthChk_View),
            Trade_RfdBthChk_ViewLs("交易流水查看", Trade_RfdBthChk_View),
      Trade_RfdBthRef("退款处理", Trade),
        Trade_RfdBthRef_Dl("下载", Trade_RfdBthRef),
        Trade_RfdBthRef_ProcPas("审核通过", Trade_RfdBthRef),
        Trade_RfdBthRef_ProcRef("拒绝", Trade_RfdBthRef),
        Trade_RfdBthRef_ViewBatNo("批次查看", Trade_RfdBthRef),
            Trade_RfdBthRef_BatchNo("批次查看", Trade_RfdBthRef_ViewBatNo),
            Trade_RfdBthRef_TradeNo("交易流水查看", Trade_RfdBthRef_ViewBatNo),
            Trade_RfdBthRef_BankNo("银行订单查看", Trade_RfdBthRef_ViewBatNo),
//                Trade_RfdBthRef_GwNo("网关订单查看", Trade_RfdBthRef_BankNo),
        Trade_RfdBthRef_ViewBankNo("银行订单查看", Trade_RfdBthRef),
//            Trade_RfdBthRef_ViewGwNo("网关订单查看", Trade_RfdBthRef_ViewBankNo),
        Trade_RfdBthRef_ViewLs("交易流水查看", Trade_RfdBthRef),
      Trade_RfdBthReChk("退款复核", Trade),
        Trade_RfdBthReChk_Dl("下载", Trade_RfdBthReChk),
        Trade_RfdBthReChk_ProcPas("复核通过", Trade_RfdBthReChk),
        Trade_RfdBthReChk_ProcRef("复核拒绝", Trade_RfdBthReChk),
        Trade_RfdBthReChk_ALIProcPas("支付宝直连退款", Trade_RfdBthReChk),
        Trade_RfdBthReChk_ViewBatNo("批次查看", Trade_RfdBthReChk),
            Trade_RfdBthReChk_BatchNo("批次查看", Trade_RfdBthReChk_ViewBatNo),
            Trade_RfdBthReChk_BankNo("银行订单查看", Trade_RfdBthReChk_ViewBatNo),
//                Trade_RfdBthReChk_GwNo("网关订单查看", Trade_RfdBthReChk_BankNo),
            Trade_RfdBthReChk_TradeNo("交易流水查看", Trade_RfdBthReChk_ViewBatNo),
        Trade_RfdBthReChk_ViewLs("交易流水查看", Trade_RfdBthReChk),
        Trade_RfdBthReChk_ViewBankNo("银行订单查看", Trade_RfdBthReChk),
//            Trade_RfdBthReChk_ViewGwNo("网关订单查看", Trade_RfdBthReChk_ViewBankNo),
      Trade_RfdHis("退款历史明细", Trade),
        Trade_RfdHis_Dl("下载", Trade_RfdHis),
        Trade_RfdHis_ViewBatNo("批次查看", Trade_RfdHis),
            Trade_RfdHis_BatchNo("批次查看", Trade_RfdHis_ViewBatNo),
            Trade_RfdHis_BankNo("银行订单查看", Trade_RfdHis_ViewBatNo),
//                Trade_RfdHis_GwNo("网关订单查看", Trade_RfdHis_BankNo),
            Trade_RfdHis_TradeNo("交易流水查看", Trade_RfdHis_ViewBatNo),
        Trade_RfdHis_ViewBankNo("银行订单查看", Trade_RfdHis),
//            Trade_RfdHis_ViewGwNo("网关订单查看", Trade_RfdHis_ViewBankNo),
        Trade_RfdHis_ViewLs("交易流水查看", Trade_RfdHis),
    Risk("风险管理", ROOT),
      Risk_Event("风险事件", Risk),
    Report("系统报表", ROOT),
      Report_BankDaily("银行交易日报", Report),
	  Report_BankDaily_DL("下载",Report_BankDaily),
      Report_CustDaily("客户交易日报", Report),
	  Report_CustDaily_DL("下载",Report_CustDaily),
      Report_FeeDaily("系统手续费日报", Report),
	  Report_FeeDaily_DL("下载",Report_FeeDaily),
      Report_FailDaily("差错交易日报", Report),
	  Report_FailDaily_DL("下载",Report_FailDaily),
      Report_BankTypeDaily("按银行划分系统数据统计表", Report),
           Report_BankTypeDaily_Dl("下载",Report_BankTypeDaily),
      Report_PersonPortalShow("个人门户报表", Report),
	  Report_PersonPortalShow_DL("下载", Report_PersonPortalShow),
      Report_OtherBizShow("其他业务统计报表", Report),
      Report_AdjustShow("调账类统计报表", Report),
    Report_AgentcollDaily("代收业务统计报表", Report),
    Report_AgentcollDaily_Dl("下载",Report_AgentcollDaily),
      Report_AgentpayDaily("代付业务统计报表", Report),
    Report_AgentpayDaily_Dl("下载",Report_AgentpayDaily),
      Report_OnlinePayDaily("在线支付业务统计报表", Report),
    Report_OnlinePayDaily_Dl("下载",Report_OnlinePayDaily),
      Report_RoyaltyDaily("分润业务统计报表", Report),
    Report_RoyaltyDaily_Dl("下载",Report_RoyaltyDaily),
     Report_AllServicesDaily("龙通宝业务统计总报表", Report),
    Report_AllServicesDaily_Dl("下载",Report_AllServicesDaily),
    InterruptOrder("订单掉单管理", ROOT),
      InterruptOrder_Manage("订单掉单处理", InterruptOrder),
        InterruptOrder_Manage_setting("通知名单设置", InterruptOrder_Manage),
        InterruptOrder_Manage_Dl("下载", InterruptOrder_Manage),
        InterruptOrder_Manage_ViewOutTradeNo("商户订单号查看", InterruptOrder_Manage),
        InterruptOrder_Manage_ViewUser("客户查看", InterruptOrder_Manage),
      InterruptOrder_Watcher_Setting("通知名单设置", InterruptOrder),
        InterruptOrder_Watcher_AddUser("添加通知人", InterruptOrder_Watcher_Setting),
        InterruptOrder_Watcher_View("查看", InterruptOrder_Watcher_Setting),
            InterruptOrder_Watcher_Update("编辑", InterruptOrder_Watcher_View),
            InterruptOrder_Watcher_Del("删除", InterruptOrder_Watcher_View),
     OP_MANAGER("运营管理", ROOT),
        OP_MANAGER_Property("资产管理", OP_MANAGER),
        OP_MANAGER_Safe("安全事件管理", OP_MANAGER),
        OP__Risk_Event("风险事件管理", OP_MANAGER),

    News("信息发布管理", ROOT),
      News_Manage("信息发布管理", News),
        News_Manage_New("创建", News_Manage),
        News_Manage_View("查看", News_Manage),
          News_Manage_Edit("编辑", News_Manage_View),
          News_Manage_Del("删除", News_Manage_View),


    Settle("清结算管理", ROOT),
      Settle_SrvType("业务类型管理", Settle),
        Settle_SrvType_New("创建", Settle_SrvType),
        Settle_SrvType_View("查看", Settle_SrvType),
        Settle_SrvType_Edit("编辑", Settle_SrvType_View),
      Settle_TradeType("业务交易类型管理", Settle),
        Settle_TradeType_New("创建", Settle_TradeType),
        Settle_TradeType_View("查看", Settle_TradeType),
          Settle_TradeType_Edit("编辑", Settle_TradeType_View),
      Settle_Fee("费率管理", Settle),
        Settle_Fee_View("查看", Settle_Fee),
          Settle_Fee_Edit("编辑", Settle_Fee_View),
           Settle_Fee_Check("审核", Settle_Fee_Edit),
      Settle_Cycle("结算周期管理", Settle),
        Settle_Cycle_View("查看", Settle_Cycle),
          Settle_Cycle_Edit("编辑", Settle_Cycle_View),
      Settle_PreManualSettle("净额即即扣手续费手工结算", Settle),
        Settle_PreManualSettle_Detail("查询明细", Settle_PreManualSettle),
        Settle_PreManualSettle_Manual("生成结算单", Settle_PreManualSettle),
      Settle_PostManualSettle("后返手续费手工结算", Settle),
        Settle_PostManualSettle_Proc("处理", Settle_PostManualSettle),
          Settle_PostManualSettle_Proc_View("查看明细", Settle_PostManualSettle_Proc),
          Settle_PostManualSettle_Proc_Gen("生成", Settle_PostManualSettle_Proc),
      Settle_PreSettleChk("结算单审核", Settle),
        Settle_PreSettleChk_Detail("查看明细", Settle_PreSettleChk),
        Settle_PreSettleChk_Proc("处理", Settle_PreSettleChk),
      Settle_SettleHis("结算历史查询", Settle),
        Settle_SettleHis_Detail("查看明细", Settle_SettleHis),
      Settle_PostSettleChk("后返手续费结算审核", Settle),
        Settle_PostSettleChk_Detail("查看明细", Settle_PostSettleChk),
        Settle_PostSettleChk_Proc("处理", Settle_PostSettleChk),
      Settle_PostSettleHis("后返手续费结算历史查询", Settle),
        Settle_PostSettleHis_Detail("查看明细", Settle_PostSettleHis),
      Settle_withDraw("客户提现", Settle),
	  Settle_AutoWithDrawCycleSetting("自动提现周期设置", Settle),
    Security("安全管理", ROOT),
       Security_Op("操作员管理", Security),
        Security_Op_New("创建操作员", Security_Op),
        Security_Op_Status("停用/启用", Security_Op),
        Security_Op_View("查看", Security_Op),
          Security_Op_Edit("编辑", Security_Op_View),
          Security_Op_Del("删除", Security_Op_View),
      Security_Role("角色管理", Security),
        Security_Role_New("创建", Security_Role),
        Security_Role_View("查看", Security_Role),
          Security_Role_Edit("编辑", Security_Role_View),

    Security_BranchCompany("分公司管理", Security),
     Security_BranchCompany_New("创建", Security_BranchCompany),
    Security_BranchCompany_Dl("下载", Security_BranchCompany),
        Security_BranchCompany_View("查看", Security_BranchCompany),
          Security_BranchCompany_Edit("编辑", Security_BranchCompany_View),
          Security_BranchCompany_Del("删除", Security_BranchCompany_View),

//      Security_Crt("证书管理", Security),
//        Security_Crt_Install("安装", Security_Crt),
//        Security_Crt_Del("删除", Security_Crt),
      SysLog("系统日志", ROOT),
        SysLog_Merc("商户交易日志", SysLog),
          SysLog_Merc_Notify("发送通知", SysLog_Merc),
      SysLog_Op_Log("BOSS后台操作日志查询", SysLog),
      SysLog_Op_Relation("BOSS后台操作名称管理", SysLog),
        SysLog_Op_Relation_New("创建", SysLog_Op_Relation),
        SysLog_Op_Relation_View("查看", SysLog_Op_Relation),
          SysLog_Op_Relation_Edit("编辑", SysLog_Op_Relation_View),
          SysLog_Op_Relation_Del("删除", SysLog_Op_Relation_View),
      SysLog_Cm_Op_Log("商户后台操作日志查询", SysLog),
      SysLog_Cm_Op_Relation("商户后台操作名称管理", SysLog),
        SysLog_Cm_Op_Relation_New("创建", SysLog_Cm_Op_Relation),
        SysLog_Cm_Op_Relation_View("查看", SysLog_Cm_Op_Relation),
          SysLog_Cm_Op_Relation_Edit("编辑", SysLog_Cm_Op_Relation_View),
          SysLog_Cm_Op_Relation_Del("删除", SysLog_Cm_Op_Relation_View),
      SysLog_Cm_Login_Log("商户后台登陆日志", SysLog),
	  SysLog_Boss_Login_Log("业务后台登陆日志", SysLog),

    RiskManager("风控管理", ROOT),
    RiskManager_InsideBlackList("内部黑名单管理", RiskManager),
	    RiskManager_BackList_Open("黑名单开启", RiskManager_InsideBlackList),
	    RiskManager_BackList_Open_Audit("黑名单开启审核", RiskManager_InsideBlackList),
	    RiskManager_BackList_Close("黑名单关闭", RiskManager_InsideBlackList),
	    RiskManager_BackList_Close_Audit("黑名单关闭审核", RiskManager_InsideBlackList),

    RiskManager_BlackList("黑名单管理", RiskManager),
        RiskManager_BlackList_NewCust("创建企业黑名单",RiskManager_BlackList),
        RiskManager_BlackList_ViewCust("查看企业黑名单",RiskManager_BlackList),
        RiskManager_BlackList_EditCust("编辑企业黑名单",RiskManager_BlackList_ViewCust),
        RiskManager_BlackList_DelCust("删除企业黑名单",RiskManager_BlackList),
        RiskManager_BlackList_DownloadCust("下载企业黑名单",RiskManager_BlackList),
        RiskManager_BlackList_UploadCust("上传企业黑名单",RiskManager_BlackList),
        RiskManager_BlackList_SearchCust("检索企业黑名单",RiskManager_BlackList),

        RiskManager_BlackList_NewPer("创建个人黑名单",RiskManager_BlackList),
        RiskManager_BlackList_ViewPer("查看企业黑名单",RiskManager_BlackList),
        RiskManager_BlackList_EditPer("编辑个人黑名单",RiskManager_BlackList_ViewCust),
        RiskManager_BlackList_DelPer("删除个人黑名单",RiskManager_BlackList),
        RiskManager_BlackList_DownloadPer("下载个人黑名单",RiskManager_BlackList),
        RiskManager_BlackList_UploadPer("上传个人黑名单",RiskManager_BlackList),
        RiskManager_BlackList_SearchPer("检索企业黑名单",RiskManager_BlackList),


    RiskManager_Risk_Rule("交易规则管理", RiskManager),
	    RiskManager_Risk_Rule_Query("交易规则管理查询", RiskManager_Risk_Rule),
	    RiskManager_Risk_Rule_Create("交易规则管理创建", RiskManager_Risk_Rule),
	    RiskManager_Risk_Rule_View("交易规则管理查看", RiskManager_Risk_Rule),
	    RiskManager_Risk_Rule_Edit("交易规则管理编辑", RiskManager_Risk_Rule),
	    RiskManager_Risk_Rule_Delete("交易规则管理删除", RiskManager_Risk_Rule),
	    RiskManager_Risk_Rule_Audit("交易规则管理审核", RiskManager_Risk_Rule),

    RiskManager_Risk_List("风险交易列表", RiskManager),
    RiskManager_Risk_Notifier("风险通知人", RiskManager),


             ;

  //权限名字
  private String label;
  //上级结点
  private Perm parent;
  //下级节点列表
  private List<Perm> children = null;

  private Perm(String label, Perm parent) {
    this.label = label;
    this.parent = parent;
    if (parent != null) {
      parent.appendChild(this);
    }
  }

  //添加下级节点
  public void appendChild(Perm child) {
    if (children == null) {
      children = new ArrayList<Perm>();
    }
    children.add(child);
  }

  public String getLabel() {
    return label;
  }

  public Perm getParent() {
    return parent;
  }

  public List<Perm> getChildren() {
    return children;
  }

  public List<Perm> getAllChildren(){
      List<Perm> rst = new ArrayList<Perm>();
      rst.add(this);

      if(null == this.children){
          return rst;
      }

      for(Perm p : this.children){
          List<Perm> son = p.getAllChildren();
          rst.addAll(son);
      }

      return rst;
  }

  public List<Perm> getAllParencts(){
      List<Perm> rst = new ArrayList<Perm>();
      rst.add(this);

      if(parent.equals(ROOT)){
          return rst;
      }

      rst.addAll(parent.getAllParencts());

      return rst;
  }

  public String toString() {
    return label;
  }
}
