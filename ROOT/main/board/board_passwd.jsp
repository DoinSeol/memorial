<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>

<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%@ page import="java.text.SimpleDateFormat, java.util.Calendar, java.util.Date" %>
<%@ page import="java.text.*" %>

<jsp:useBean id="stl"      class="goodit.common.dao.DBUtil"      scope="page"/>
<jsp:useBean id="str_util" class="goodit.common.util.StringUtil" scope="page"/>

<%@ include file="board_control.jsp" %>

<%

// ------------------------------------------------------------------------------------------------------
// 변수선언
// ------------------------------------------------------------------------------------------------------


int i = 0;
String sql = "";


// Record

int rs_seqid = 0;
int rs_no = 0;
int rs_bu_seqid = 0;
int rs_bref = 0;
int rs_blevel = 0;
int rs_bstep = 0;
int rs_bhit = 0;

String rs_cid = "";
String rs_bu_name = "";
String rs_bu_email = "";
String rs_bu_pwd = "";
String rs_bsubject = "";
String rs_bcontent = "";
String rs_btag = "";
String rs_inst_date = "";


// Request

String req_unify_str = "";

String rq_cid = "";
String rq_method = "";
String rq_target = "";
String rq_idx = "";
String rq_mode = "";


String rq_bref = "";
String rq_bstep = "";
String rq_blevel = "";



rq_cid    = str_util.getArgsCheck(request.getParameter("cmsid"));
rq_method = str_util.getArgsCheck(request.getParameter("method"));
rq_target = str_util.getArgsCheck(request.getParameter("target"));
rq_idx    = str_util.getArgsCheck(request.getParameter("idx"));
rq_mode   = str_util.getArgsCheck(request.getParameter("mode"));

rq_bref   = str_util.getArgsCheck(request.getParameter("b_ref"));
rq_bstep  = str_util.getArgsCheck(request.getParameter("b_step"));
rq_blevel = str_util.getArgsCheck(request.getParameter("b_level"));

if(rq_cid == null) rq_cid = "";

if(rq_idx == null) rq_idx = "";
if(rq_bref == null) rq_bref = "";
if(rq_bstep == null) rq_bstep = "";
if(rq_blevel == null) rq_blevel = "";

if(rq_target == null || rq_target.equals("")) rq_target = "";


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

request_str = "cmsid=" + rq_cid + "&target=" + rq_target + "&psize=" + rq_page_size + "&st=" + rq_search_type + "&sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

req_unify_str = "";
req_unify_str = req_unify_str + "cmsid=" + rq_cid + "&target=" + rq_target + "&psize=" + rq_page_size;
req_unify_str = req_unify_str + "&st=" + rq_search_type + "&sk=" + URLEncoder.encode(rq_search_key, "UTF-8");
// ------------------------------------------------------------------------------------------------------



// ------------------------------------------------------------------------------------------------------
// 수정/삭제 권한이 있는지 체크
// ------------------------------------------------------------------------------------------------------
if((rq_mode.equals("e") && (rs_inc_am.equals("1") || rs_inc_am_r.equals("1"))) || (rq_mode.equals("") && (rs_inc_ad.equals("1") || rs_inc_ad_r.equals("1"))))
{


sql = "";
sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') ";
sql = sql + "from board ";
sql = sql + "where cid = '" + rq_cid + "' and seqid = " + rq_idx;


ResultSet rs_list = stl.executeQuery(sql);

if(rs_list.next())
{
  
  rs_seqid       = rs_list.getInt(1);
  rs_cid         = rs_list.getString(2);
  rs_no          = rs_list.getInt(3);
  rs_bu_seqid    = rs_list.getInt(4);
  rs_bu_name     = rs_list.getString(5);
  rs_bu_email    = rs_list.getString(6);
  rs_bu_pwd      = rs_list.getString(7);
  rs_bref        = rs_list.getInt(8);
  rs_blevel      = rs_list.getInt(9);
  rs_bstep       = rs_list.getInt(10);
  rs_bsubject    = rs_list.getString(11);
  
  rs_bcontent    = stl.getClobToString(rs_list, "bcontent");
  
  rs_btag        = rs_list.getString(13);
  rs_bhit        = rs_list.getInt(14);
  rs_inst_date   = rs_list.getString(15);
  
  if(rs_inc_bsecret_view.equals("3")) { rs_bu_name = "***"; }
  
}


if(stl!=null) { 
	stl.close(); 
	stl = null;
}


%>


<script language="JavaScript">
<!--

function fun_send_form()
{
   var form = document.board_form;
   
   if (form.bu_pwd.value=="")
   { 
      alert("\n비밀번호를 입력하세요.");
      form.bu_pwd.focus();
      return;
   }
   form.submit();
}
    
//-->
</script>


<script type="text/javascript" src="/main/js/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="/main/js/color.js"></script>

<script type="text/javascript">
//테이블 컬러 설정

  //기본값
  //var pointColor = '#e0144c';
  //var mainColor = '#005bb0';

  var pointColor = '#007d08';
  var mainColor = '#333';

</script>



    <form name="board_form" method="post" action="board/board_passwd_check.jsp">
      
    <input type="hidden" name="target"    value="<%=rq_target%>" />
    <input type="hidden" name="cmsid"     value="<%=rq_cid%>" />
    <input type="hidden" name="idx"       value="<%=rq_idx%>" />
    <input type="hidden" name="mode"      value="<%=rq_mode%>" />
    
    <input type="hidden" name="psize"     value="<%=rq_page_size%>" />
    <input type="hidden" name="page"      value="<%=rq_page%>" />
    <input type="hidden" name="st"        value="<%=rq_search_type%>" />
    <input type="hidden" name="sk"        value="<%=rq_search_key%>" />
    
    <input type="hidden" name="b_ref"     value="<%=rq_bref%>" />
    <input type="hidden" name="b_step"    value="<%=rq_bstep%>" />
    <input type="hidden" name="b_level"   value="<%=rq_blevel%>" />

    <table class="basic_table" >
		<caption class="HIDE">
			<strong>${menu_title} 비밀번호</strong>
			<p>${menu_title} 비밀번호 항목(작성자, 제목, 비밀번호) 나타내고 있습니다.</p>
      <tr class="first_line">
        <th scope="row" width="20%" class="left">작성자</th>
        <td width="" ><%=rs_bu_name%></td>
      </tr>
      
      <tr>
        <th scope="row" width="20%" class="left">제 목</th>
        <td width=""><%=rs_bsubject%></td>
      </tr>
      
      
      <tr>
        <th scope="row" width="20%" class="left" >비밀번호</th>
        <td width="" ><input type="password" name="bu_pwd" class="input" size="15" maxlength="15" value="" id="bu_pwd"></td>
      </tr>
      
    </table>
    
    <div class="b_button">
      <a class="typeA" href="#fun_send_form" onclick="javascript:fun_send_form(); return false;">확인</a>
      <a class="typeB" href="board.do?<%=req_unify_str%>&method=v&idx=<%=rq_idx%>&page=<%=rq_page%>">취소</a>
    </div>
    
    </form>
    
  </div>
</div>



<%
}

// ------------------------------------------------------------------------------------------------------
// 수정/삭제 권한이 없을때 처리
// ------------------------------------------------------------------------------------------------------
else
{
  if(stl!=null) { stl.close(); stl = null; }

  out.println("<form name='board_form' method='post' action='board.do'>");
  
  out.println("<input type='hidden' name='method'    value=''>");
  out.println("<input type='hidden' name='target'    value='" + rq_target + "'>");
  out.println("<input type='hidden' name='cmsid'     value='" + rq_cid + "'>");
  out.println("<input type='hidden' name='mode'      value=''>");
  
  out.println("<input type='hidden' name='psize'     value='" + rq_page_size + "'>");
  out.println("<input type='hidden' name='page'      value='" + rq_page + "'>");
  out.println("<input type='hidden' name='st'        value='" + rq_search_type + "'>");
  out.println("<input type='hidden' name='sk'        value='" + rq_search_key + "'>");
  
  out.println("</form>");
  
  out.println("<script language='JavaScript'>");
  out.println("<!--");
  out.println("  var form = document.board_form;");
  out.println("  alert('게시판 사용권한이 없습니다.');");
  out.println("  form.method.value = 'l';");
  out.println("  form.submit();");
  out.println("-->");
  out.println("</script>");
}

if(stl!=null) { 
	stl.close(); 
	stl = null;
}

%>