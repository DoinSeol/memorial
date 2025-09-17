
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<!--%@ page import="oracle.jdbc.internal.OracleTypes" %-->
<!--%@ page import="oracle.sql.*" %-->
<!--%@ page import="oracle.jdbc.internal.*" %-->

<jsp:useBean id="stl"      class="goodit.common.dao.DBUtil"      scope="page"/>
<jsp:useBean id="str_util" class="goodit.common.util.StringUtil" scope="page"/>

<%@ include file="board_control.jsp" %>

<%

int i = 0;
String sql = "";
String target_str = "";

// Record
String rs_bu_id = "";
String rs_bu_pwd = "";
String rs_fname_s = "";


// Request
String rq_cid = "";
String rq_method = "";
String rq_target = "";
String rq_idx = "";
String rq_mode = "";

String rq_bref = "";
String rq_bstep = "";
String rq_blevel = "";

String rq_bu_pwd = "";



rq_cid      = str_util.getArgsCheck(request.getParameter("cmsid"));
rq_method   = str_util.getArgsCheck(request.getParameter("method"));
rq_target   = str_util.getArgsCheck(request.getParameter("target"));
rq_idx      = str_util.getArgsCheck(request.getParameter("idx"));
rq_mode     = str_util.getArgsCheck(request.getParameter("mode"));

rq_bref     = str_util.getArgsCheck(request.getParameter("b_ref"));
rq_bstep    = str_util.getArgsCheck(request.getParameter("b_step"));
rq_blevel   = str_util.getArgsCheck(request.getParameter("b_level"));

rq_bu_pwd   = str_util.getArgsCheck(request.getParameter("bu_pwd"));

if(rq_target == null || rq_target.equals("")) rq_target = "";
if(rq_bu_pwd == null || rq_bu_pwd.equals("")) rq_bu_pwd = "";

if(rq_cid == null) rq_cid = "";
if(rq_idx == null) rq_idx = "";

if("".equals(rq_cid) || "".equals(rq_idx)) 
{  
  if(stl!=null) {  stl.close();  stl = null; }
  
  //out.println("<div id='wrap'>입력항목에 문제가 있습니다.</div>");
  
  String message_url = "/main/messagebox.action?cmsid=" + rq_cid + "&url=/&msg=" + URLEncoder.encode("잘못된 경로에 접근하셨습니다.", "UTF-8");
  
  out.println("<script type=\"text/javascript\">");
  out.println("//<![CDATA[");
  out.println("document.location.href = \"" + message_url + "\";");
  out.println("//]]>");
  out.println("</script>");
  
  return;
}


// ------------------------------------------------------------------------------------------------------
// 검색
// ------------------------------------------------------------------------------------------------------
String rq_search_type = "-1";
String rq_search_key = "";
String rq_page_size = "";
String rq_page = "";

String request_str = "";
String request_where_str = "";

rq_page_size   = str_util.getArgsCheck(request.getParameter("psize"));
rq_page        = str_util.getArgsCheck(request.getParameter("page"));
rq_search_type = str_util.getArgsCheck(request.getParameter("st"));
rq_search_key  = str_util.getArgsCheck(request.getParameter("sk"));

if(rq_page == null || rq_page == "") rq_page = "1";
if(rq_search_type == null || rq_search_type == "") rq_search_type = "0";
if(rq_search_key == null || rq_search_key == "") rq_search_key = "";

request_str = "cmsid=" + rq_cid + "&page=" + rq_page + "&target=" + rq_target + "&psize=" + rq_page_size + "&st=" + rq_search_type + "&sk=" + URLEncoder.encode(rq_search_key, "UTF-8");
// ------------------------------------------------------------------------------------------------------



if(rq_target.equals(""))
{
  target_str = "./../";
}
else
{
  target_str = "/" + rq_target + "/";
}






// ------------------------------------------------------------------------------------------------------
// 삭제 권한이 있는지 체크
// ------------------------------------------------------------------------------------------------------
if((rq_mode.equals("e") && (rs_inc_am.equals("1") || rs_inc_am_r.equals("1"))) || (rq_mode.equals("") && (rs_inc_ad.equals("1") || rs_inc_ad_r.equals("1"))))
{


// ------------------------------------------------------------------------------------------------------
// 비밀번호 일치 확인
// ------------------------------------------------------------------------------------------------------
sql = "select bu_id, bu_pwd From board where cid='" + rq_cid + "' and seqid=" + rq_idx;
ResultSet rs_pwd = stl.executeQuery(sql);

if(rs_pwd.next())
{
  rs_bu_id  = rs_pwd.getString(1);
  rs_bu_pwd = rs_pwd.getString(2);
}
else
{
  rs_pwd.close();
  if(stl!=null) { 
    stl.close(); 
    stl = null;
  }
  response.sendRedirect(target_str + "messagebox.action?cmsid=" + rq_cid + "&msg=" + URLEncoder.encode("존재하지 않는 정보 입니다.", "UTF-8"));
}
rs_pwd.close();


if(!rq_bu_pwd.equals(rs_bu_pwd))
{
  if(stl!=null) { 
    stl.close(); 
    stl = null;
  }
  response.sendRedirect(target_str + "messagebox.action?cmsid=" + rq_cid + "&msg=" + URLEncoder.encode("입력하신 비밀번호가 일치 하지 않습니다.<br><br> 다시 입력하세요", "UTF-8"));
}
  
if(stl!=null) { 
	stl.close(); 
	stl = null;
}

%>

<form name="board_form" method="post" action="<%=target_str%>board.action">

<input type="hidden" name="method"    value="<%=rq_mode%>" />
<input type="hidden" name="target"    value="<%=rq_target%>" />
<input type="hidden" name="cmsid"     value="<%=rq_cid%>" />
<input type="hidden" name="idx"       value="<%=rq_idx%>" />
<input type="hidden" name="mode"      value="" />
<input type="hidden" name="passwd"    value="ok" />

<input type="hidden" name="psize"     value="<%=rq_page_size%>" />
<input type="hidden" name="page"      value="<%=rq_page%>" />
<input type="hidden" name="st"        value="<%=rq_search_type%>" />
<input type="hidden" name="sk"        value="<%=rq_search_key%>" />

<input type="hidden" name="b_ref"     value="<%=rq_bref%>" />
<input type="hidden" name="b_step"    value="<%=rq_bstep%>" />
<input type="hidden" name="b_level"   value="<%=rq_blevel%>" />

</form>

<script language='JavaScript'>
<!--

var form = document.board_form;
form.submit();

-->
</script>

<%

if(stl!=null) { 
	stl.close(); 
	stl = null;
}


}


// ------------------------------------------------------------------------------------------------------
// 삭제 권한이 없을때 처리
// ------------------------------------------------------------------------------------------------------
else
{
  if(stl!=null) 
  {
    stl.close(); 
    stl = null;
  }
  
  String msg_str = URLEncoder.encode("세션 시간이 만료되어 사용자 정보가 없습니다. 또는 잘못된 경로로 접근 하셨습니다.", "UTF-8");
  //response.sendRedirect("messagebox.jbe?cmsid=" + rq_cid + "&url=/&msg=" + msg_str);
  
  response.sendRedirect(target_str + "messagebox.action?cmsid=" + rq_cid + "&url=/&msg=" + msg_str);
  
}

%>