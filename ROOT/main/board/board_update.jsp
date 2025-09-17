<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ page import="oracle.jdbc.internal.OracleTypes" %>
<%@ page import="oracle.sql.*" %>
<%@ page import="oracle.jdbc.internal.*" %>

<jsp:useBean id="stl"      class="goodit.common.dao.DBUtil"      scope="page"/>
<jsp:useBean id="str_util" class="goodit.common.util.StringUtil" scope="page"/>

<%@ include file="board_control.jsp" %>

<%


int i = 0;
String target_str = "";

int intMaxNum = 0;
String sql = "";
String ip_address = request.getRemoteAddr();
String bu_id = "";

// Record
int rs_bseqid = 0;
int rs_bno = 0;

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

String rq_bclass = "";
String rq_bu_name = "";
String rq_bu_email = "";
String rq_bu_pwd = "";
String rq_bsubject = "";
String rq_bcontent = "";
String rq_btag = "";
String rq_bsecret = "";


rq_cid      = str_util.getArgsCheck(request.getParameter("cmsid"));
rq_method   = str_util.getArgsCheck(request.getParameter("method"));
rq_target   = str_util.getArgsCheck(request.getParameter("target"));
rq_idx      = str_util.getArgsCheck(request.getParameter("idx"));
rq_mode     = str_util.getArgsCheck(request.getParameter("mode"));

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


if(rq_bsubject != null && rq_bsubject != "")
{
  rq_bsubject = rq_bsubject.replaceAll("<", "&lt;");
  rq_bsubject = rq_bsubject.replaceAll(">", "&gt;");
  rq_bsubject = rq_bsubject.replaceAll("\'", "`");
  rq_bsubject = rq_bsubject.replaceAll("\"", "`");
  
  //rq_bsubject = rq_bsubject.replaceAll("\n", "<br>");
}


int rq_bref_int = 0;
int rq_bstep_int = 0;
int rq_blevel_int = 0;


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


// 문자형 --> 숫자형 변환
/*
if(rq_bref != null) rq_bref_int = Integer.parseInt(rq_bref);
else rq_bref_int = 0;

if(rq_bstep != null) rq_bstep_int = Integer.parseInt(rq_bstep);
else rq_bstep_int = 0;

if(rq_blevel != null) rq_blevel_int = Integer.parseInt(rq_blevel);
else rq_blevel_int = 0;
*/

rq_bref_int = 0;
rq_bstep_int = 0;
rq_blevel_int = 0;


if(rq_target == null || rq_target.equals("")) rq_target = "";
if(rq_btag == null || rq_btag.equals("")) rq_btag = "";
if(rq_bsecret == null || rq_bsecret.equals("")) rq_bsecret = "0";

if(rq_bclass == null || rq_bclass.equals("")) rq_bclass = "0";


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


if(rq_target.equals(""))
{
  target_str = "./../";
}
else
{
  target_str = "/" + rq_target + "/";
}



// ------------------------------------------------------------------------------------------------------
// 수정/삭제 권한이 있는지 체크
// ------------------------------------------------------------------------------------------------------
if(rs_inc_am.equals("1") || rs_inc_am_r.equals("1") || rs_inc_ad.equals("1") || rs_inc_ad_r.equals("1"))
{

// ------------------------------------------------------------------------------------------------------
// 비밀번호 일치 확인
// ------------------------------------------------------------------------------------------------------
sql = "select bno, bu_id, bu_pwd From board where cid='" + rq_cid + "' and seqid=" + rq_idx + " ";

// 휴지통
if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";

ResultSet rs_pwd = stl.executeQuery(sql);

if(rs_pwd.next())
{
  rs_bno    = rs_pwd.getInt(1);
  rs_bu_id  = rs_pwd.getString(2);
  rs_bu_pwd = rs_pwd.getString(3);
}
else
{
  rs_pwd.close();
  if(stl!=null)
  { 
    stl.close(); 
    stl = null;
  }
  response.sendRedirect(target_str + "messagebox.action?cmsid=" + rq_cid + "&msg=" + URLEncoder.encode("존재하지 않는 정보 입니다.", "UTF-8"));
}
rs_pwd.close();

//out.println(rq_bu_pwd);
//out.println(rs_bu_pwd);

// 비회원 작성한 글 (로그아웃)
if(rs_inc_bu_id.equals("") && inc_admin.equals(""))
{
  if(!rq_bu_pwd.equals(rs_bu_pwd))
  {
    if(stl!=null)
    { 
      stl.close(); 
      stl = null;
    }
    response.sendRedirect(target_str + "messagebox.action?cmsid=" + rq_cid + "&msg=" + URLEncoder.encode("입력하신 비밀번호가 일치 하지 않습니다.<br><br> 다시 입력하세요", "UTF-8"));
  }
  
  bu_id = "";
  
}
// 회원 작성한 글 (로그인)
else
{
  // 관리자(X) : 일반 사용자면 비밀번호 확인
  if(inc_admin.equals(""))
  {
    if(session.getAttribute("session_login_id") == null || !session.getAttribute("session_login_id").equals(rs_bu_id))
    {
      if(stl!=null) 
      { 
        stl.close(); 
        stl = null;
      }
      response.sendRedirect(target_str + "messagebox.action?cmsid=" + rq_cid + "&msg=" + URLEncoder.encode("수정 및 삭제 할 수 있는 권한이 없습니다.", "UTF-8"));
    }
  }
  
  if(session.getAttribute("session_login_id") != null) bu_id = session.getAttribute("session_login_id").toString();
}

// ------------------------------------------------------------------------------------------------------


// 수정
if(rq_mode.equals("1"))
{
  
  stl.setAutoCommit(false);
  
  sql = "";
  sql = sql + "update board set ";
  sql = sql + "bsubject = ?, bcontent = CHAR_TO_CLOB(?), ";
  
  sql = sql + "bclass = ?, ";
  
  if(!rq_btag.equals("")) { sql = sql + "btag = ?, "; }
  if(rs_inc_bsecret_view.equals("1")) { sql = sql + "bsecret = ?, "; }
  
  sql = sql + "updt_id = ?, updt_date = sysdatetime, updt_ip = ? ";
  
  sql = sql + "where cid = ? and seqid = ? ";
  
  // 휴지통
  if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
  
  stl.setQuery(sql);
  
  i = 1;
  
  stl.setString(i++, rq_bsubject);
  stl.setString(i++, rq_bcontent);
  
  stl.setString(i++, rq_bclass);
  
  if(!rq_btag.equals("")) { stl.setString(i++, rq_btag); }
  if(rs_inc_bsecret_view.equals("1")) { stl.setString(i++, rq_bsecret); }
  
  stl.setString(i++, bu_id);
  stl.setString(i++, ip_address);
  
  stl.setString(i++, rq_cid);
  stl.setString(i++, rq_idx);
  
  stl.executeUpdate();
  
  stl.close_pstmt();
  
  
  /*
  sql = "select bcontent from board where cid = '" + rq_cid + "' and seqid = " + rq_idx + " ";
  // 휴지통
  if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
  sql = sql + " for update";
  ResultSet rs = stl.executeQuery(sql);
  if(rs.next())
  {
    CLOB cl = ((OracleResultSet)rs).getCLOB("bcontent");
    
    // 스트림을 이용한 값 저장
    BufferedWriter writer = new BufferedWriter(cl.getCharacterOutputStream());
    writer.write(rq_bcontent);
    writer.close();
  }
  */
  
  stl.commit();
  stl.setAutoCommit(true);
  
  
  // ------------------------------------------------------------------------------------------------------
  // 첨부파일 추가
  // ------------------------------------------------------------------------------------------------------
  sql = "update board_file set bseqid = " + rq_idx + ", freg = '1', fstate='', fsession ='' where cid = '" + rq_cid + "' and fsession = '" + session.getId() + "' and fstate = 'i'";
  stl.executeUpdate(sql);
  
  
  // ------------------------------------------------------------------------------------------------------
  // 첨부파일 삭제
  // ------------------------------------------------------------------------------------------------------
  
  // 업로드된 파일이 저장될 서버의 절대경로
  String savePath = request.getRealPath("/upload/board");
  
  sql = "";
  sql = sql + "select fname_s ";
  sql = sql + "from board_file ";
  sql = sql + "where cid = '" + rq_cid + "' ";
  sql = sql + "and freg = '0' and fstate = 'd' ";
  sql = sql + "and fsession = '" + session.getId() + "' ";
  sql = sql + "and (bseqid = 0 or bseqid = " + rq_idx + ") ";
  
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
  sql = "delete from board_file ";
  sql = sql + "where cid = '" + rq_cid + "' ";
  sql = sql + "and freg = '0' and fstate = 'd' ";
  sql = sql + "and fsession = '" + session.getId() + "' ";
  sql = sql + "and (bseqid = 0 or bseqid = " + rq_idx + ") ";
  stl.executeUpdate(sql);
  
  rs_files.close();
  rs_files = null;
  
}

// 삭제
else if(rq_mode.equals("2"))
{
  //sql = "update board set bno = bno - 1 where cid = '" + rq_cid + "' and bno > " + rs_bno;
  //stl.executeUpdate(sql);
  
  //sql = "delete from board where cid = '" + rq_cid + "' and seqid = " + rq_idx;
  //stl.executeUpdate(sql);
  
  // 휴지통 사용
  sql = "update board set brecycle = '1' where cid = '" + rq_cid + "' and seqid = " + rq_idx;
  stl.executeUpdate(sql);
  
  
  // ---------------------------------------------------------------------------
  // 임시 첨부파일 삭제
  // ---------------------------------------------------------------------------
  
  /*
  // 업로드된 파일이 저장될 서버의 절대경로
  String savePath = request.getRealPath("/upload/board");
  
  sql = "";
  sql = sql + "select fname_s ";
  sql = sql + "from board_file ";
  sql = sql + "where cid = '" + rq_cid + "' and bseqid = " + rq_idx;
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
  
  // 첨부파일의 정보 삭제
  sql = "delete from board_file where cid = '" + rq_cid + "' and bseqid = " + rq_idx;
  stl.executeUpdate(sql);
  
  rs_files.close();
  rs_files = null;
  */
}

if(stl!=null) { 
	stl.close(); 
	stl = null;
}


response.sendRedirect(target_str + "board.action?" + request_str);

}


// ------------------------------------------------------------------------------------------------------
// 수정/삭제 권한이 없을때 처리
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