<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%@ page import="java.text.SimpleDateFormat, java.util.Calendar, java.util.Date" %>
<%@ page import="java.text.*" %>

<%@ page import="goodit.common.dao.*"%>

<jsp:useBean id="stl"      class="goodit.common.dao.DBUtil"      scope="page"/>
<jsp:useBean id="str_util" class="goodit.common.util.StringUtil" scope="page"/>


<c:set var="currentUrl"  value="${requestScope['struts.request_uri']}?${pageContext.request.queryString}" scope="request" />

<c:url var="loginUrl" value="/login/loginForm.action">
  <c:param name="url">${currentUrl}</c:param>
</c:url>


<%@ include file="board_control.jsp" %>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");


DBUtil dbset = null;

dbset = new DBUtil();


String url_context_path = "";
//url_context_path = request.getRequestURL().toString();
//java.net.URL urls = new  java.net.URL(url_context_path);
//url_context_path = urls.getPath();
//url_context_path = url_context_path.substring(0, url_context_path.lastIndexOf("/")).toString();

// 게시글 읽기권한 확인
if(rs_inc_av.equals("1"))
{
  
  // ------------------------------------------------------------------------------------------------------
  // 변수선언
  // ------------------------------------------------------------------------------------------------------
  
  int i = 0;
  
  String sql = "";
  String url_path = "";
  
  int record_file_count = 0;
  
  // Record
  
  int rs_seqid = 0;
  int rs_no = 0;
  int rs_bu_seqid = 0;
  int rs_bref = 0;
  int rs_blevel = 0;
  int rs_bstep = 0;
  int rs_bhit = 0;
  int rs_fimage_w = 0;
  int rs_fimage_h = 0;
  
  int rs_a_seqid = 0;
  int rs_a_no = 0;
  int rs_a_bu_seqid = 0;
  int rs_a_bref = 0;
  int rs_a_blevel = 0;
  int rs_a_bstep = 0;
  int rs_a_bhit = 0;
  
  String rs_cid = "";
  String rs_bu_name = "";
  String rs_bu_dept_nm = "";
  String rs_bu_email = "";
  String rs_bu_pwd = "";
  String rs_bsubject = "";
  String rs_bcontent = "";
  String rs_btag = "";
  String rs_inst_date = "";
  
  String rs_a_cid = "";
  String rs_a_bu_name = "";
  String rs_a_bu_dept_nm = "";
  String rs_a_bu_email = "";
  String rs_a_bu_pwd = "";
  String rs_a_bsubject = "";
  String rs_a_bcontent = "";
  String rs_a_btag = "";
  String rs_a_inst_date = "";
  
  int rs_fidx = 0;
  String rs_fname_s = "";
  String rs_fname_o = "";
  
  int rs_prv_seqid = 0;
  int rs_next_seqid = 0;
  String rs_prv_bsubject = "";
  String rs_next_bsubject = "";
  
  
  // Request
  
  String req_unify_str = "";
  
  String rq_cid = "";
  String rq_method = "";
  String rq_target = "";
  String rq_idx = "";
  
  String rq_bref = "";
  String rq_bstep = "";
  String rq_blevel = "";
  
  String rq_passwd = "";
  
  
  rq_cid    = str_util.getArgsCheck(request.getParameter("cmsid"));
  rq_method = str_util.getArgsCheck(request.getParameter("method"));
  rq_target = str_util.getArgsCheck(request.getParameter("target"));
  rq_idx    = str_util.getArgsCheck(request.getParameter("idx"));
  
  rq_bref   = str_util.getArgsCheck(request.getParameter("b_ref"));
  rq_bstep  = str_util.getArgsCheck(request.getParameter("b_step"));
  rq_blevel = str_util.getArgsCheck(request.getParameter("b_level"));
  
  rq_passwd = str_util.getArgsCheck(request.getParameter("passwd"));
  
  if(rq_cid == null) rq_cid = "";
  if(rq_idx == null) rq_idx = "";
  if(rq_bref == null) rq_bref = "";
  if(rq_bstep == null) rq_bstep = "";
  if(rq_blevel == null) rq_blevel = "";
  
  if(rq_target == null || rq_target.equals("")) rq_target = "";
  if(rq_passwd == null || rq_passwd.equals("")) rq_passwd = "";
  
  
  if("".equals(rq_cid) || "".equals(rq_idx))
  {  
    if(dbset != null) { dbset.close(); dbset = null; }
    if(stl != null) { stl.close(); stl = null; }
    
    //out.println("<div id='content'>입력항목에 문제가 있습니다.</div>");
    
    String message_url = "/main/messagebox.action?cmsid=" + rq_cid + "&url=/&msg=" + URLEncoder.encode("잘못된 경로에 접근하셨습니다.", "UTF-8");
    
    out.println("<script type=\"text/javascript\">");
    out.println("//<![CDATA[");
    out.println("document.location.href = \"" + message_url + "\";");
    out.println("//]]>");
    out.println("</script>");
    
    return;
  }
  
  //out.println(rq_idx);
  //out.println(str_util.isNumeric("53027"));
  
  
  
  // ------------------------------------------------------------------------------------------------------
  // 검색
  // ------------------------------------------------------------------------------------------------------
  String rq_class_cd = "";
  String rq_search_type = "-1";
  String rq_search_key = "";
  String rq_page_size = "";
  String rq_page = "";
  
  String request_str = "";
  String request_where_str = "";
  
  rq_class_cd    = str_util.getArgsCheck(request.getParameter("cc"));
  rq_page_size   = str_util.getArgsCheck(request.getParameter("psize"));
  rq_page        = str_util.getArgsCheck(request.getParameter("page"));
  rq_search_type = str_util.getArgsCheck(request.getParameter("st"));
  rq_search_key  = str_util.getArgsCheck(request.getParameter("sk"));
  
  if(rq_class_cd == null || rq_class_cd == "") rq_class_cd = "";
  if(rq_page == null || rq_page == "") rq_page = "1";
  if(rq_search_type == null || rq_search_type == "") rq_search_type = "0";
  if(rq_search_key == null || rq_search_key == "") rq_search_key = "";
  
  request_str = "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;cc=" + rq_class_cd + "&amp;psize=" + rq_page_size + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");
  
  req_unify_str = "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;cc=" + rq_class_cd + "&amp;psize=" + rq_page_size + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");
  
  // ------------------------------------------------------------------------------------------------------
  
  
  
  
  
  
  
  // ------------------------------------------------------------------------------------------------------
  // 조건식에 의한 SQL문 만들기
  // ------------------------------------------------------------------------------------------------------
  if(rq_search_type != "" && rq_search_key != "")
  {
    if(rq_search_type.equals("0"))
    {
      request_where_str = request_where_str + " and bsubject like '%" + rq_search_key + "%' ";
    }
    else if(rq_search_type.equals("1"))
    {
      //request_where_str = request_where_str + " and DBMS_LOB.INSTR(bcontent, '" + rq_search_key + "') > 0 ";
      request_where_str = request_where_str + " and POSITION('" + rq_search_key + "' IN bcontent) > 0 ";

    }
    else if(rq_search_type.equals("2"))
    {
      request_where_str = request_where_str + " and bu_name like '%" + rq_search_key + "%' ";
    }
  }
  // ------------------------------------------------------------------------------------------------------
  
  
  sql = "";
  //sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_dept_nm, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') ";
  sql = sql + "select seqid, cid, bno, bu_seqid, bu_name,  bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') ";
  sql = sql + "from board ";
  sql = sql + "where cid = '" + rq_cid + "' and seqid = " + rq_idx + " ";
  
  // 휴지통
  //if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
  sql = sql + "and brecycle = '0' ";
  
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
    
    if(rs_bu_name == null) { rs_bu_name = ""; }
    
    
    
    
    if(rs_bcontent != null && rs_bcontent != "")
    {
      if(rs_btag.equals("0"))
      {
        rs_bcontent = rs_bcontent.replaceAll("<", "&lt;");
        rs_bcontent = rs_bcontent.replaceAll(">", "&gt;");
        
        rs_bcontent = rs_bcontent.replaceAll("\n", "<br/>");
        //rs_bcontent = rs_bcontent.replaceAll("\r", "<br/>");
      }
      else if(rs_btag.equals("2"))
      {
        rs_bcontent = rs_bcontent.replaceAll("<script", "&lt;script");
        rs_bcontent = rs_bcontent.replaceAll("</script", "/&lt;script");
        rs_bcontent = rs_bcontent.replaceAll("<body", "&lt;body");
        rs_bcontent = rs_bcontent.replaceAll("<iframe", "&lt;iframe");
        
        rs_bcontent = rs_bcontent.replaceAll("\n", "<br/>");
        //rs_bcontent = rs_bcontent.replaceAll("\r", "<br/>");
      }
      else
      {
        rs_bcontent = rs_bcontent.replaceAll("<script", "&lt;script");
        rs_bcontent = rs_bcontent.replaceAll("</script", "/&lt;script");
        rs_bcontent = rs_bcontent.replaceAll("<body", "&lt;body");
        rs_bcontent = rs_bcontent.replaceAll("<iframe", "&lt;iframe");
      }
    }

    // 읽은수 증가
    sql = "update board set bhit = bhit + 1 ";
    sql = sql + "where cid = '" + rq_cid + "' and seqid = " + rq_idx;

    stl.executeUpdate(sql);
    // commit()을 안해줄경우 동작이 안되는 경우가 있어서 확인이 필요합니다.
    stl.commit();
  }
  
  rs_list.close();
  
  
  // ------------------------------------------------------------------------------------------------------
  // 답변형
  // ------------------------------------------------------------------------------------------------------
  if(rs_inc_btype.equals("2"))
  {
    sql = "";
    //sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_dept_nm, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') ";
    sql = sql + "select seqid, cid, bno, bu_seqid, bu_name,  bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd') ";
    sql = sql + "from board ";
    sql = sql + "where cid = '" + rq_cid + "' and bref = " + rq_idx + " and blevel = 1 and bstep = 1 ";
    
    // 휴지통
    //if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
    sql = sql + "and brecycle = '0' ";
    
    ResultSet rs_list_a = stl.executeQuery(sql);
    
    if(rs_list_a.next())
    {
      rs_a_seqid       = rs_list_a.getInt(1);
      rs_a_cid         = rs_list_a.getString(2);
      rs_a_no          = rs_list_a.getInt(3);
      rs_a_bu_seqid    = rs_list_a.getInt(4);
      rs_a_bu_name     = rs_list_a.getString(5);
      rs_a_bu_email    = rs_list_a.getString(6);
      rs_a_bu_pwd      = rs_list_a.getString(7);
      rs_a_bref        = rs_list_a.getInt(8);
      rs_a_blevel      = rs_list_a.getInt(9);
      rs_a_bstep       = rs_list_a.getInt(10);
      rs_a_bsubject    = rs_list_a.getString(11);
      
      rs_a_bcontent    = stl.getClobToString(rs_list_a, "bcontent");
      
      rs_a_btag        = rs_list_a.getString(13);
      rs_a_bhit        = rs_list_a.getInt(14);
      rs_a_inst_date   = rs_list_a.getString(15);
      
 
      
      if(rs_inc_bsecret_view.equals("3")) { rs_a_bu_name = "***"; }
      
      
      if(rs_a_bcontent != null && rs_a_bcontent != "")
      {
        if(rs_a_btag.equals("0"))
        {
          rs_a_bcontent = rs_a_bcontent.replaceAll("<", "&lt;");
          rs_a_bcontent = rs_a_bcontent.replaceAll(">", "&gt;");
          
          rs_a_bcontent = rs_a_bcontent.replaceAll("\n", "<br/>");
          //rs_a_bcontent = rs_a_bcontent.replaceAll("\r", "<br/>");
        }
        else if(rs_a_btag.equals("2"))
        {
          rs_a_bcontent = rs_a_bcontent.replaceAll("<script", "&lt;script");
          rs_a_bcontent = rs_a_bcontent.replaceAll("</script", "/&lt;script");
          rs_a_bcontent = rs_a_bcontent.replaceAll("<body", "&lt;body");
          rs_a_bcontent = rs_a_bcontent.replaceAll("<iframe", "&lt;iframe");
          
          rs_a_bcontent = rs_a_bcontent.replaceAll("\n", "<br/>");
          //rs_a_bcontent = rs_a_bcontent.replaceAll("\r", "<br/>");
        }
        else
        {
          rs_a_bcontent = rs_a_bcontent.replaceAll("<script", "&lt;script");
          rs_a_bcontent = rs_a_bcontent.replaceAll("</script", "/&lt;script");
          rs_a_bcontent = rs_a_bcontent.replaceAll("<body", "&lt;body");
          rs_a_bcontent = rs_a_bcontent.replaceAll("<iframe", "&lt;iframe");
        }
      }
    }
    
    rs_list_a.close();
  }
  
  
  
  // ------------------------------------------------------------------------------------------------------
  // 이전글
  // ------------------------------------------------------------------------------------------------------
  sql = "";
  //sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') from ( ";
  sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd') from ( ";
  sql = sql + "select rownum as rnum, b.* from ( ";
  
  sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, inst_date ";
  sql = sql + "from board ";
  sql = sql + "where cid = '" + rq_cid + "' ";
  
  // 글 작성자만 열람
  if(rs_inc_bsecret_list.equals("2") && inc_admin.equals("")) sql = sql + "and bu_id = '" + inc_login_id + "' ";
  
  sql = sql + "and blevel = 0 and seqid > " + rq_idx + " and bref != " + rs_bref + " ";
  
  // 휴지통
  //if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
  sql = sql + "and brecycle = '0' ";
  
  sql = sql + request_where_str;
  
  //sql = sql + " order by bnotice desc, seqid asc ";
  sql = sql + " order by bref asc, bstep asc ";
  
  sql = sql + ") b ";
  sql = sql + ") a ";
  sql = sql + "where a.rnum > 0 and a.rnum <= 1 ";
  
  ResultSet rs_list_prv = stl.executeQuery(sql);
  
  if(rs_list_prv.next())
  {
    rs_prv_seqid    = rs_list_prv.getInt(1);
    rs_prv_bsubject = rs_list_prv.getString(11);
  }
  
  rs_list_prv.close();
  // ------------------------------------------------------------------------------------------------------
  
  
  // ------------------------------------------------------------------------------------------------------
  // 다음글
  // ------------------------------------------------------------------------------------------------------
  sql = "";
  //sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') from ( ";
  sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd') from ( ";
  sql = sql + "select rownum as rnum, b.* from ( ";
  
  sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, inst_date ";
  sql = sql + "from board ";
  sql = sql + "where cid = '" + rq_cid + "' ";
  
  // 글 작성자만 열람
  if(rs_inc_bsecret_list.equals("2") && inc_admin.equals("")) sql = sql + "and bu_id = '" + inc_login_id + "' ";
  
  sql = sql + "and blevel = 0 and seqid < " + rq_idx + " and bref != " + rs_bref + " ";
  
  // 휴지통
  //if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
  sql = sql + "and brecycle = '0' ";
  
  sql = sql + request_where_str;
  
  //sql = sql + " order by bnotice desc, seqid desc ";
  sql = sql + " order by bref desc, bstep asc ";
  
  sql = sql + ") b ";
  sql = sql + ") a ";
  sql = sql + "where a.rnum > 0 and a.rnum <= 1 ";
  
  ResultSet rs_list_next = stl.executeQuery(sql);
  
  if(rs_list_next.next())
  {
    rs_next_seqid    = rs_list_next.getInt(1);
    rs_next_bsubject = rs_list_next.getString(11);
  }
  
  rs_list_next.close();
  // ------------------------------------------------------------------------------------------------------
  
  
  // ------------------------------------------------------------------------------------------------------
  // 첨부파일
  // ------------------------------------------------------------------------------------------------------
  
  // 첨부파일 갯수
  sql = "";
  sql = "select count(*) from board_file ";
  sql = sql + "where cid = '" + rq_cid + "' and bseqid = " + rq_idx + " and freg = '1'";
  ResultSet rs_files_count = stl.executeQuery(sql);
  
  if(rs_files_count != null)
  {
    rs_files_count.next();
    record_file_count = rs_files_count.getInt(1);
  }
  rs_files_count.close();
  rs_files_count = null;
  
  
  // 첨부파일 목록
  sql = "";
  sql = sql + "select seqid, fname_o, fname_s ";
  sql = sql + "from board_file ";
  sql = sql + "where cid = '" + rq_cid + "' and bseqid = " + rq_idx + " and freg = '1' ";
  sql = sql + "order by seqid asc ";
  ResultSet rs_files = stl.executeQuery(sql);
  
  
  // 첨부 파일이 사진이면 첫번째 사진을 다음 특수 문자료 변환
  // [image] [image_c] [image_r] [image_l]
  if(record_file_count > 0)
  {
    sql = "";
    sql = sql + "select fname_s, fimage_w, fimage_h ";
    sql = sql + "from board_file ";
    sql = sql + "where cid = '" + rq_cid + "' and bseqid = " + rq_idx + " and freg = '1' ";
    sql = sql + "order by seqid asc ";
    ResultSet rs_files_img = stl.executeQuery(sql);
   
  
    if(rs_files_img.next())
    {
      // 파일 저장 URL
      url_path = stl.getPath(rq_cid, 0, "rel");
      
      rs_fname_s  = rs_files_img.getString(1);
      rs_fimage_w = rs_files_img.getInt(2);
      rs_fimage_h = rs_files_img.getInt(3);
      
      if(rs_fimage_w > 650) rs_fimage_w = 650;
      
      rs_bcontent = rs_bcontent.replaceAll("@image_c@", "<center><img src='" + url_path + "/upload/board/" + rs_fname_s + "' border='0' width='" + rs_fimage_w + "' /></center>");
      rs_bcontent = rs_bcontent.replaceAll("@image_l@", "<img src='" + url_path + "/upload/board/" + rs_fname_s + "' border='0' width='" + rs_fimage_w + "' align='left' />");
      rs_bcontent = rs_bcontent.replaceAll("@image_r@", "<img src='" + url_path + "/upload/board/" + rs_fname_s + "' border='0' width='" + rs_fimage_w + "' align='right' />");
      
      rs_bcontent = rs_bcontent.replaceAll("@image@", url_path + "/upload/board/" + rs_fname_s);
      
    }
    
    rs_files_img.close();
  }
  
  // ------------------------------------------------------------------------------------------------------
  
  %>
  
  
  <script type="text/javascript">
  //<![CDATA[
  
  function fun_reply(idx)
  {
    var form = document.board_form;
    
    form.action = "board.do"
    form.method.value = "w";
    form.idx.value = idx;
    form.submit();
  }
  
  function fun_edit(idx)
  {
    var form = document.board_form;
    form.action = "board.do"
    
    <%
    if(rs_inc_bu_id.equals("") && inc_admin.equals(""))
    {
    %>
    
    form.method.value = "p";
    form.mode.value = "e";
    form.idx.value = idx;
    
    <%
    }
    else
    {
    %>
    
    form.method.value = "e";
    form.mode.value = "";
    form.idx.value = idx;
    
    <%
    }
    %>
    
    form.submit();
  }
  
  function fun_delete(idx)
  {
    var form = document.board_form;
    
    if(confirm("\n삭제 하시겠습니까?") == true)
    {
      form.method.value = "d";
      form.idx.value = idx;
      
      <%
      if(rs_inc_bu_id.equals("") && inc_admin.equals(""))
      {
      %>
      
      form.action = "board.do"
      form.mode.value = "";
      
      <%
      }
      else
      {
      %>
      
      form.action = "board/board_update.jsp"
      form.mode.value = "2";
      
      <%
      }
      %>
      
      form.submit();
     }
  }
  
  function fun_reply_edit(idx)
  {
    var form = document.board_form;
    form.action = "board.do"
    
    form.method.value = "e";
    form.mode.value = "";
    form.idx.value = idx;
    
    form.submit();
    
  }
  
  function fun_reply_delete(idx)
  {
    var form = document.board_form;
    
    if(confirm("\n삭제 하시겠습니까?") == true)
    {
      form.method.value = "d";
      form.idx.value = idx;
      
      form.action = "board/board_update.jsp"
      form.mode.value = "2";
      
      form.submit();
     }
     
  }
  
  function fun_list()
  {
    var form = document.board_form;
    form.action = "board.do"
    
    form.method.value = "l";
    form.submit();
  }
  
  function fun_prv(idx)
  {
    var form = document.board_form;
    form.action = "board.do"
    
    form.method.value = "v";
    form.idx.value = idx;
    form.submit();
  }
  
  function fun_next(idx)
  {
    var form = document.board_form;
    form.action = "board.do"
    
    form.method.value = "v";
    form.idx.value = idx;
    form.submit();
  }
  
  
  // 파일 다운로드
  function fun_download(idx)
  {
    var form = document.board_form;
    form.action = "/upload/download.jsp"
    
    form.idx.value = idx;
    
    form.submit();
  }
  
  //]]>
  </script>
  
  
  
  
  <form name="board_form" method="post" action="board.do">
    
  <input type="hidden" name="method"    value="" />
  <input type="hidden" name="target"    value="<%=rq_target%>" />
  <input type="hidden" name="cmsid"     value="<%=rq_cid%>" />
  <input type="hidden" name="bidx"      value="<%=rs_seqid%>" />
  <input type="hidden" name="idx"       value="<%=rq_idx%>" />
  <input type="hidden" name="mode"      value="" />
  
  <input type="hidden" name="cc"        value="<%=rq_class_cd%>" />
  <input type="hidden" name="psize"     value="<%=rq_page_size%>" />
  <input type="hidden" name="page"      value="<%=rq_page%>" />
  <input type="hidden" name="st"        value="<%=rq_search_type%>" />
  <input type="hidden" name="sk"        value="<%=rq_search_key%>" />
  
  <input type="hidden" name="b_ref"     value="<%=rs_bref%>" />
  <input type="hidden" name="b_step"    value="<%=rs_bstep%>" />
  <input type="hidden" name="b_level"   value="<%=rs_blevel%>" />
  <!-- <input type="submit" value="" class="hidden" /> -->
  
  </form>
      
      <table class="basic_table">
        
        <caption class="HIDE">
    				</caption>
        
    				<colgroup>
    					<col width="20%">
    					<col width="80%">
    				</colgroup>
        
        <tr class="first_line">
          <th scope="row" width="20%" class="left">작성자</th>
          <td scope="col" width="80%"><%=rs_bu_name%></td>
        </tr>
        
        <tr>
          <th scope="row" width="20%" class="left">작성일</th>
          <td><%=rs_inst_date%></td>
        </tr>
    
        <tr>
          <th scope="row" width="20%" class="left">제목</th>
          <td><%=rs_bsubject%></td>
        </tr>

				  </table>
			
   
    <div class="table_con" style="padding-bottom:30px;"><span class="t_con"><%=rs_bcontent%></span></div>
    
				<table class="basic_table no_t">
      
      <caption class="HIDE">
   			</caption>
				  
  				<colgroup>
 	  				<col width="20%">
	 		  		<col>
				  </colgroup>			
                   
        <%
        if(rs_seqid > 0 && record_file_count > 0)
        {
        %>
        
        <!-- 첨부파일 -->        
        <tr> 
      				<th scope="row" width="20%" class="left">첨부파일</th>
					     <td>
           <%
           
           int file_pos= 0;
           String file_ext = "";
           String files_img = "";
           String synap_chk = "";
           
           while(rs_files.next())
           {
             synap_chk = "";
             
             rs_fidx    = rs_files.getInt(1);
             rs_fname_o = rs_files.getString(2);
             rs_fname_s = rs_files.getString(3);
             
													if(rs_fname_o != null && !rs_fname_o.equals(""))
									    {
															file_pos  = rs_fname_o.lastIndexOf(".");           // 확장자
															file_ext  = rs_fname_o.substring(file_pos + 1);
															
															if(file_ext.equals("hwp")) { synap_chk = "O"; files_img = "<img src='images/file/hwp.gif' alt='한글파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("pdf")) { synap_chk = "O"; files_img = "<img src='images/file/pdf.gif' alt='PDF파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("ppt") || file_ext.equals("pptx")) { synap_chk = "O"; files_img = files_img + "<img src='images/file/ppt.gif' alt='액셀파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("xls") || file_ext.equals("xlsx")) { synap_chk = "O"; files_img = "<img src='images/file/xls.gif' alt='액셀파일' width='16' height='16' border='0' />"; }
               else if(file_ext.equals("doc") || file_ext.equals("docx")) { files_img = files_img + "<img src='images/file/docx.gif' alt='워드파일' width='16' height='16' border='0' />"; }
               else if(file_ext.equals("ai")) { files_img = files_img + "<img src='images/file/ai.gif' alt='일러스트파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("zip") || file_ext.equals("arj") || file_ext.equals("alz") || file_ext.equals("rar") || file_ext.equals("egg ")) { files_img = "<img src='images/file/zip.gif' alt='압축파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("jpg") || file_ext.equals("JPG")) { files_img = "<img src='images/file/jpg.gif' alt='이미지파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("png") || file_ext.equals("PNG")) { files_img = "<img src='images/file/png.gif' alt='이미지파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("gif") || file_ext.equals("GIF")) { files_img = "<img src='images/file/gif.gif' alt='이미지파일' width='16' height='16' border='0' />"; }
															else if(file_ext.equals("wmv") || file_ext.equals("mp4") || file_ext.equals("avi") || file_ext.equals("mov")) { files_img = "<img src='images/file/wmv.gif' alt='동영상파일' width='16' height='16' border='0' />"; }
															else { files_img = "<img src='images/file/file.gif' alt='첨부파일' width='16' height='16' border='0' />"; }
															
															out.println("<div>");
															out.println(files_img);
															out.println("<a href='/upload/download.jsp?cmsid=" + rs_cid + "&amp;bidx=" + rs_seqid + "&amp;idx=" + rs_fidx + "'>" + rs_fname_o + "</a>");															
															out.println("</div>");
													}
           }
           
           rs_files.close();
           %>
           
			      </td>
		    </tr>
    </table>


			 <!--table class="basic_table"-->
    <table>
        
        <caption class="HIDE">
    				<strong>${menu_title} 답변</strong>
    				</caption>
      		
      		<colgroup>
     					<col width="20%">
     					<col>
     					<col width="20%">
     					<col>
      		</colgroup>
        <%
        
        }
        
        if(!rs_a_bsubject.equals(""))
        {
          %>
          
          <!-- 답변 -->
          <tr><td colspan="4" class="reply" style="border-top:2px solid #50585e;">답변내용<!--img src="board/images/reply_title_bt.gif" alt="답변내용" width="73" height="23" align="middle" /--></td></tr>
          
          <!--tr>
            <th scope="row" width="20%" class="left">작성자</th>
            <td width="*"><%=rs_a_bu_name%></td>
            <th scope="row" width="20%" class="left">답변일자</th>
            <td width="*"><%=rs_a_inst_date%></td>
          </tr>
          
          <tr>
            <th scope="row" width="20%" class="left">제목</th>
            <td width="" colspan="3" ><%=rs_a_bsubject%></td>
          </tr-->
          
          <tr><td colspan="4" style="border-width:0;padding-bottom:50px;"><%=rs_a_bcontent%></td></tr>
          
          <tr>
            <td colspan="4">
                <%
                if(rs_inc_am_r.equals("1"))
                {
                %>
                
                <a class="typeA_a" href="board.do?<%=req_unify_str%>&amp;method=e&amp;mode=&amp;idx=<%=rs_a_seqid%>">수정</a>
                
                <%
                }
                %>
                <%
                if(rs_inc_ad_r.equals("1"))
                {
                %>
                
                <a class="typeA_a" href="board.do?<%=req_unify_str%>&amp;method=d&amp;mode=2&amp;idx=<%=rs_a_seqid%>">삭제</a>
                <!--<a href="board/board_update.jsp?<%=req_unify_str%>&amp;method=d&amp;mode=2&amp;idx=<%=rs_a_seqid%>"><img src="board/images/button_delete_r.gif" width="46" height="20" border="0" alt="삭제" /></a>-->
                
                <%
                }
                %>
            </td>
          </tr>
  
        <%
      }
      %>
                  
      </table>           
      <%
      // 이전글
      //if(!rs_prv_bsubject.equals(""))
      //{
      //out.println("<tr class='last_line left_bar'>");
      //out.println("  <th scope='row' width='20%'>이전글</th>");
      //out.println("  <td width='' colspan='3'><a href='board.action?" + req_unify_str + "&amp;method=v&amp;idx=" + rs_prv_seqid + "&amp;page=" + rq_page + "'>" + rs_prv_bsubject + "</a></td>");
      //out.println("</tr>");
      //}
      
      // 다음글
      //if(!rs_next_bsubject.equals(""))
      //{
      //out.println("<tr class='left_bar'>");
      //out.println("  <th scope='row' width='20%'>다음글</th>");
      //out.println("  <td width='' colspan='3'><a href='board.action?" + req_unify_str + "&amp;method=v&amp;idx=" + rs_next_seqid + "&amp;page=" + rq_page + "'>" + rs_next_bsubject + "</a></td>");
      //out.println("</tr>");
      //}
      %>
<!--       </table> -->
      
      <div class="b_button tr">
      <%
      // 답변
      if(rs_inc_btype.equals("2") && rs_inc_ar.equals("1") && rs_a_bsubject.equals(""))
      {
        out.println("<a class='typeA' href='board.do?" + req_unify_str + "&amp;method=w&amp;idx=" + rq_idx + "&amp;page=" + rq_page + "&amp;b_ref=" + rs_bref + "&amp;b_step=" + rs_bstep + "&amp;b_level=" + rs_blevel + "'>답변</a>");
      }
      
      // 수정
      if(rs_inc_am.equals("1"))
      {
        if(rs_inc_bu_id.equals("") && inc_admin.equals(""))
        {
           out.println("<a class='typeA' href='board.do?" + req_unify_str + "&amp;method=p&amp;mode=e&amp;idx=" + rq_idx + "&amp;page=" + rq_page + "'>수정</a>");
        }
        else
        {
           out.println("<a class='typeA' href='board.do?" + req_unify_str + "&amp;method=e&amp;mode=&amp;idx=" + rq_idx + "&amp;page=" + rq_page + "'>수정</a>");
        }
      }
      
      // 삭제
      if(rs_inc_ad.equals("1"))
      {
        if(rs_inc_bu_id.equals("") && inc_admin.equals(""))
        {
          out.println("<a class='typeB' href='board.do?" + req_unify_str + "&amp;method=d&amp;mode=&amp;idx=" + rq_idx + "&amp;page=" + rq_page + "'>삭제</a>");
        }
        else
        {
          out.println("<a class='typeB' href='board.do?" + req_unify_str + "&amp;method=d&amp;mode=&amp;idx=" + rq_idx + "&amp;page=" + rq_page + "'>삭제</a>");
        }
      }
      %>
      <a class='typeB' href="board.do?<%=req_unify_str%>&amp;method=l&amp;idx=&amp;page=<%=rq_page%>">목록</a>
					 </div>

						 <table class="basic_table mt_40">
							<caption class="HIDE">
							</caption>
      <%
      // 이전글
      if(!rs_prv_bsubject.equals(""))
      {
        out.println("<tr class='last_line left_bar first_line'>");
        out.println("  <th scope='row' width='20%'>이전글</th>");
        out.println("  <td width='' colspan='3'><a href='board.do?" + req_unify_str + "&amp;method=v&amp;idx=" + rs_prv_seqid + "&amp;page=" + rq_page + "'>" + rs_prv_bsubject + "</a></td>");
        out.println("</tr>");
      }
      
      // 다음글
      if(!rs_next_bsubject.equals(""))
      {
        out.println("<tr class='left_bar first_line'>");
        out.println("  <th scope='row' width='20%'>다음글</th>");
        out.println("  <td width='' colspan='3'><a href='board.do?" + req_unify_str + "&amp;method=v&amp;idx=" + rs_next_seqid + "&amp;page=" + rq_page + "'>" + rs_next_bsubject + "</a></td>");
        out.println("</tr>");
      }
      %>
      </table>
<!--       </div> -->

  
  <%
  // 비회원 + 비밀글
  if(rs_inc_bu_id.equals("") && ((rs_inc_bsecret_view.equals("1")
     && rs_inc_bsecret.equals("1")) || rs_inc_bsecret_view.equals("2"))
     && inc_admin.equals("")
     && !rq_passwd.equals("ok"))
  {
    if(dbset != null) { dbset.close(); dbset = null; }
    if(stl!=null) { stl.close(); stl = null; }

    out.println("<script type='text/javascript'>");
    out.println("<!--");
    out.println("  var form = document.board_form;");
    out.println("  form.method.value = 'p';");
    out.println("  form.mode.value = 'v';");
    out.println("  form.submit();");
    out.println("-->");
    out.println("</script>");
  }
}
else
{
  
  if(!rs_inc_bsecret_view.equals("0") && !rs_inc_bsecret_view.equals("3") && session.getAttribute("session_login_id") == null)
  {
    %>
    
    <div class="con_box">
     <dl> 
      <%
      if(rs_inc_blogin_img != null && !rs_inc_blogin_img.equals(""))
      {
        out.println("<div style='text-align:center'><img src='board/images/" + rs_inc_blogin_img + "' alt='" + rs_inc_blogin_img_alt + "' /></div>");
      }
      %>
     	<dt class="tc"><span class="blue">본인확인</span> 또는 <span class="blue">공공아이핀(I-PIN)</span>으로 로그인을 하여 이용하실 수 있습니다.<br> 아래 버튼을 누르시면 로그인창으로 이동합니다.</dt>
      <!--div style='text-align:center'><a href='/login/loginForm.do?url=<%=url_context_path%>/board.do?cmsid=<%=inc_rq_cid%>'>로그인(Login)</a></div-->
      <dd class="tc mt_20"><a href='${loginUrl}' class="btn_app" title="로그인(Login)">로그인(Login)</a></dd>
     </dl>
		   
    </div>
    
    <%
  }
  else
  {
    if(dbset != null) { dbset.close(); dbset = null; }
    if(stl!=null) { stl.close(); stl = null; }

    out.println("<script type='text/javascript'>");
    out.println("<!--");
    out.println("  alert('게시판 글을 볼 수 있는 권한이 없거나, 별도의 인증(로그인)이 필요한 게시판 입니다.');");
    out.println("  history.back();");
    out.println("-->");
    out.println("</script>");
  }
  
}


if(dbset != null) { dbset.close(); dbset = null; }

if(stl!=null) { stl.close(); stl = null; }

%>

