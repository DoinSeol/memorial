<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ page import="oracle.jdbc.internal.OracleTypes" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.internal.*" %>

<%@ page import="goodit.common.dao.*" %>
<%@ page import="goodit.common.util.StringUtil"%>

<jsp:useBean id="stl"      class="goodit.common.dao.DBUtil"      scope="page"/>
<jsp:useBean id="str_util" class="goodit.common.util.StringUtil" scope="page"/>

<%@ include file="board_control.jsp" %>

<%
//DB 접속
DBUtil dbset = new DBUtil();

int i = 0;
String target_str = "";

int intMaxNum = 0;
String sql = "";
String ip_address = request.getRemoteAddr();
String bu_id = "";
String bu_vDiscrNo = "";

// Record
int seq_board = 0;


// Request
String rq_cid = "";
String rq_method = "";
String rq_target = "";
String rq_idx = "";

String rq_bref = "";
String rq_bstep = "";
String rq_blevel = "";

String rq_bclass = "";
String rq_bu_name = "";
String rq_bu_email = "";
String rq_bu_pwd = "";
String rq_bsubject = "";
String rq_bcontent = "";
String rq_btag = "";
String rq_bsecret = "";

String rs_fname_s = "";

int rq_bref_int = 0;
int rq_bstep_int = 0;
int rq_blevel_int = 0;


rq_cid      = str_util.getArgsCheck(request.getParameter("cmsid"));
rq_method   = str_util.getArgsCheck(request.getParameter("method"));
rq_target   = str_util.getArgsCheck(request.getParameter("target"));
rq_idx      = str_util.getArgsCheck(request.getParameter("idx"));

rq_bref     = str_util.getArgsCheck(request.getParameter("b_ref"));
rq_bstep    = str_util.getArgsCheck(request.getParameter("b_step"));
rq_blevel   = str_util.getArgsCheck(request.getParameter("b_level"));

rq_bclass   = request.getParameter("b_class");
rq_bu_name  = request.getParameter("bu_name");
rq_bu_email = request.getParameter("bu_email");
rq_bu_pwd   = request.getParameter("bu_pwd");
rq_bsubject = request.getParameter("b_subject");
rq_bcontent = request.getParameter("b_content");
rq_btag     = request.getParameter("b_tag");
rq_bsecret  = request.getParameter("b_secret");


if(rq_idx == null || rq_idx.equals("")) rq_idx = "";
if(rq_target == null || rq_target.equals("")) rq_target = "";
if(rq_btag == null || rq_btag.equals("")) rq_btag = "0";
if(rq_bsecret == null || rq_bsecret.equals("")) rq_bsecret = "0";

if(rq_bclass == null || rq_bclass.equals("")) rq_bclass = "0";
if(rq_bu_name == null || rq_bu_name.equals("")) rq_bu_name = "";
if(rq_bu_email == null || rq_bu_email.equals("")) rq_bu_email = "";
if(rq_bu_pwd == null || rq_bu_pwd.equals("")) rq_bu_pwd = "";
if(rq_bsubject == null || rq_bsubject.equals("")) rq_bsubject = "";
if(rq_bcontent == null || rq_bcontent.equals("")) rq_bcontent = "";

if(rq_bsubject != null && rq_bsubject != "")
{
  rq_bsubject = rq_bsubject.replaceAll("<", "&lt;");
  rq_bsubject = rq_bsubject.replaceAll(">", "&gt;");
  rq_bsubject = rq_bsubject.replaceAll("\'", "`");
  rq_bsubject = rq_bsubject.replaceAll("\"", "`");
  
  //rq_bsubject = rq_bsubject.replaceAll("\n", "<br>");
}

if(rq_cid==null) { rq_cid = ""; }


if("".equals(rq_cid)) 
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


// 문자형 --> 숫자형 변환
if(rq_bref != null && !rq_bref.equals("")) rq_bref_int = Integer.parseInt(rq_bref);
else rq_bref_int = 0;

if(rq_bstep != null && !rq_bstep.equals("")) rq_bstep_int = Integer.parseInt(rq_bstep);
else rq_bstep_int = 0;

if(rq_blevel != null && !rq_blevel.equals("")) rq_blevel_int = Integer.parseInt(rq_blevel);
else rq_blevel_int = 0;



if(rq_idx == null || rq_idx.equals("")) rq_idx = "";
if(rq_btag == null || rq_btag.equals("")) rq_btag = "0";
if(rq_target == null || rq_target.equals("")) rq_target = "";



// ------------------------------------------------------------------------------------------------------
// 검색
// ------------------------------------------------------------------------------------------------------
String rq_search_type = "-1";
String rq_search_key = "";
String rq_page = "";

String request_str = "";
String request_where_str = "";

rq_page        = request.getParameter("page");
rq_search_type = request.getParameter("st");
rq_search_key  = request.getParameter("sk");

if(rq_page == null || rq_page == "") rq_page = "1";
if(rq_search_type == null || rq_search_type == "") rq_search_type = "0";
if(rq_search_key == null || rq_search_key == "") rq_search_key = "";

request_str = "cmsid=" + rq_cid + "&page=" + rq_page + "&target=" + rq_target + "&st=" + rq_search_type + "&sk=" + URLEncoder.encode(rq_search_key, "UTF-8");
// ------------------------------------------------------------------------------------------------------




// ------------------------------------------------------------------------------------------------------
// 로그인 사용자 일때
// ------------------------------------------------------------------------------------------------------
if(session.getAttribute("session_login_id") != null)
{
  sql = "select uemail, passwd from USER_INFO where id = '" + session.getAttribute("session_login_id") + "'";
  ResultSet rs_user = stl.executeQuery(sql);
  
  if(rs_user.next())
  {
    rq_bu_email = rs_user.getString(1);
    rq_bu_pwd   = rs_user.getString(2);
  }
  rs_user.close();
  
  if(rq_bu_email == null) rq_bu_email = "";
  if(rq_bu_pwd == null) rq_bu_pwd = "";
  
  rq_bu_name  = session.getAttribute("session_login_name").toString();
  bu_id       = session.getAttribute("session_login_id").toString();
  //bu_vDiscrNo = session.getAttribute("session_login_pin").toString();
  bu_vDiscrNo = "";
}
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
// 쓰기 및 답변 권한이 있는지 체크
// ------------------------------------------------------------------------------------------------------
if((rs_inc_aw.equals("1") || rs_inc_ar.equals("1")) && !rq_bu_name.equals(""))
{
  

// ------------------------------------------------------------------------------------------------------
// Sequence
// ------------------------------------------------------------------------------------------------------
//seq_board = stl.getSeqid("SEQ_BOARD");

sql = "select SEQ_BOARD.nextval";

dbset.setQuery(sql);
ResultSet rs_seq_board = dbset.executeQuery();

if(rs_seq_board.next())
{
  seq_board = rs_seq_board.getInt(1);
}

if(rq_idx.equals(""))
{
  //rq_bref_int = seq_board;
}
else
{
  //rq_bref_int = Integer.parseInt(rq_idx);
}
// ------------------------------------------------------------------------------------------------------


// ------------------------------------------------------------------------------------------------------
// bno의 큰값
// ------------------------------------------------------------------------------------------------------
sql = "select MAX(bno) From board where cid='" + rq_cid + "'";
ResultSet rs_max = stl.executeQuery(sql);

if(!rs_max.next())
{
  intMaxNum = 1;
}
else
{
  intMaxNum = rs_max.getInt(1) + 1;
}
rs_max.close();


// ------------------------------------------------------------------------------------------------------
// 
// ------------------------------------------------------------------------------------------------------
//if(rq_idx == null || rq_idx.equals(""))
if(rq_idx == "")
{
  rq_bref_int = seq_board;
  rq_bstep_int = 0;
  rq_blevel_int = 0;
}
else
{
  sql = "";
  sql = sql + "update board set bstep = bstep + 1 ";
  sql = sql + "where cid='" + rq_cid + "' and bref = " + rq_bref_int + " and  bstep > " + rq_bstep_int;
  stl.executeUpdate(sql);
  
  rq_bstep_int  = rq_bstep_int + 1;
  rq_blevel_int = rq_blevel_int + 1;
}




stl.setAutoCommit(false);

sql = "";
sql = sql + "insert into board (";

sql = sql + "seqid, cid, bno, bclass, ";
sql = sql + "bu_seqid, bu_id, bu_name, bu_email, bu_pwd, ";
sql = sql + "bref, blevel, bstep, ";
sql = sql + "bsubject, bcontent, btag, bsecret, bhit, ";

sql = sql + "inst_id, inst_date, inst_ip";

sql = sql + ") values (";
sql = sql + "?, ?, ?, ?, ";
sql = sql + "0, ?, ?, ?, ?, ";
sql = sql + "?, ?, ?, ";

//sql = sql + "?, empty_clob(), ?, ?, 0, ";
sql = sql + "?, CHAR_TO_CLOB(?), ?, ?, 0, ";

sql = sql + "?, sysdatetime, ?)";

//out.println(sql);

stl.setQuery(sql);

i = 1;

stl.setInt(i++, seq_board);
stl.setString(i++, rq_cid);
stl.setInt(i++, intMaxNum);
stl.setString(i++, rq_bclass);

stl.setString(i++, bu_id);
stl.setString(i++, rq_bu_name);
stl.setString(i++, rq_bu_email);
stl.setString(i++, rq_bu_pwd);
//stl.setString(i++, bu_vDiscrNo);

stl.setInt(i++, rq_bref_int);
stl.setInt(i++, rq_blevel_int);
stl.setInt(i++, rq_bstep_int);

stl.setString(i++, rq_bsubject);
stl.setString(i++, rq_bcontent);
stl.setString(i++, rq_btag);
stl.setString(i++, rq_bsecret);

stl.setString(i++, bu_id);
stl.setString(i++, ip_address);

stl.executeUpdate();

stl.close_pstmt();

/*
sql = "select bcontent from board where seqid = '" + seq_board + "' for update";
ResultSet rs2 = stl.executeQuery(sql);
if(rs2.next())
{
  CLOB cl = ((OracleResultSet)rs2).getCLOB("bcontent");
  
  // 스트림을 이용한 값 저장
  BufferedWriter writer = new BufferedWriter(cl.getCharacterOutputStream());
  writer.write(rq_bcontent);
  writer.close();
}
rs2.close();
*/

stl.commit();
stl.setAutoCommit(true);



// ------------------------------------------------------------------------------------------------------
// 첨부파일 추가
// ------------------------------------------------------------------------------------------------------
sql = "update board_file set bseqid = " + seq_board + ", freg = '1', fstate='', fsession ='' where cid = '" + rq_cid + "' and fsession = '" + session.getId() + "' and fstate = 'i'";
stl.executeUpdate(sql);


// ------------------------------------------------------------------------------------------------------
// 첨부파일 삭제
// ------------------------------------------------------------------------------------------------------

// 업로드된 파일이 저장될 서버의 절대경로
String savePath = request.getRealPath("/upload/board");

// 파일 저장 경로
//String movePath = stl.getPath(rq_cid, 0, "abs");

sql = "";
sql = sql + "select fname_s ";
sql = sql + "from board_file ";
sql = sql + "where cid = '" + rq_cid + "' ";
//sql = sql + "and bseqid = " + rq_idx + " ";
sql = sql + "and freg = '0' and fstate = 'd' and fsession = '" + session.getId() + "' ";

ResultSet rs_files = stl.executeQuery(sql);

int seqid = 0;
String mfile_name = "";

while(rs_files.next())
{
  rs_fname_s = rs_files.getString(1);
  
  // 첨부파일의 파일 삭제
  //if(rs_fname_s != "") new File(movePath + "/upload/board/" + rs_fname_s).delete();
  if(rs_fname_s != "") new File(savePath + "/" + rs_fname_s).delete();
}

rs_files.close();


// 첨부파일의 정보 삭제
sql = "delete from board_file where cid = '" + rq_cid + "' and freg = '0' and fstate = 'd' and fsession = '" + session.getId() + "' ";
stl.executeUpdate(sql);

rs_files.close();
rs_files = null;

if(stl!=null) 
{ 
  stl.close(); 
  stl = null;
}


response.sendRedirect(target_str + "board.do?" + request_str);

}


// ------------------------------------------------------------------------------------------------------
// 쓰기 및 답변 권한이 없을때 처리
// ------------------------------------------------------------------------------------------------------
else
{
  if(stl!=null) 
  {
    stl.close(); 
    stl = null;
  }
  
  String msg_str = URLEncoder.encode("세션 시간이 만료되어 사용자 정보가 없습니다. 또는 잘못된 경로로 접근 하셨습니다.", "UTF-8");
  //response.sendRedirect("messagebox.action?cmsid=" + rq_cid + "&url=/&msg=" + msg_str);
  
  response.sendRedirect(target_str + "messagebox.action?cmsid=" + rq_cid + "&url=/&msg=" + msg_str);
  
}

%>
