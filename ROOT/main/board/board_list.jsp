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
ResultSet rs_file_list = null;


String url_context_path = "";
url_context_path = request.getRequestURL().toString();
java.net.URL urls = new  java.net.URL(url_context_path);
url_context_path = urls.getPath();
url_context_path = url_context_path.substring(0, url_context_path.lastIndexOf("/")).toString();


if(rs_inc_al.equals("1"))
{

// ------------------------------------------------------------------------------------------------------
// 변수선언
// ------------------------------------------------------------------------------------------------------

String[] b_search_type_array = {"제목", "내용", "작성자"};
String[] b_search_key_array  = {"", "", ""};


int i = 0;
String sql = "";

String secret_tag = "";
String state_tag = "";

// 첨부파일 확인
String files_img = "";
int rs_files_cnt = 0;

// 날짜 형식
SimpleDateFormat sdf = new SimpleDateFormat();
sdf.applyPattern("yyyy-MM-dd");



// Request

String req_unify_str = "";
String req_unify_str2 = "";
String req_unify_str3 = "";

String rq_cid = "";
String rq_method = "";
String rq_target = "";
String rq_idx = "";

rq_cid    = str_util.getArgsCheck(request.getParameter("cmsid"));
rq_method = str_util.getArgsCheck(request.getParameter("method"));
rq_target = str_util.getArgsCheck(request.getParameter("target"));
rq_idx    = str_util.getArgsCheck(request.getParameter("idx"));

if(rq_target == null || rq_target.equals("")) rq_target = "";

if(rq_cid == null) { rq_cid = ""; }

if("".equals(rq_cid))
{
  if (dbset != null) { dbset.close(); dbset = null; }
  
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


// Record
int rs_seqid = 0;
int rs_no = 0;
int rs_bu_seqid = 0;
int rs_bref = 0;
int rs_blevel = 0;
int rs_bstep = 0;
int rs_bhit = 0;
int rs_rank = 0;

String rs_cid = "";
String rs_bclass_nm = "";
String rs_bu_id = "";
String rs_bu_name = "";
String rs_bu_dept_cd = "";
String rs_bu_dept_nm = "";
String rs_bu_dept_oclass_nm = "";
String rs_bu_dept_par_nm = "";
String rs_bu_email = "";
String rs_bu_pwd = "";
String rs_bsubject = "";
String rs_bsubject_shot = "";
String rs_bcontent = "";
String rs_btag = "";
String rs_bsecret = "";
String rs_brecycle = "";
String rs_bnotice = "";

Date rs_inst_date;





// -----------------------------------------------------------------------------
// 페이징
// -----------------------------------------------------------------------------

String reqPage = "";
String reqPage_Size = "";
int pageSize = 10;
int curPage = 0;
int totPage = 0;
int lastNum = 0;

int intNumOfPage = 5;
int intStart = 0;
int intEnd = 0;

int record_count = 0;


reqPage      = str_util.getArgsCheck(request.getParameter("page"));
reqPage_Size = str_util.getArgsCheck(request.getParameter("psize"));

if(reqPage == null || reqPage.equals("")) { curPage = 1; }
else if(!str_util.isNumeric(reqPage)) curPage = 1;
else { curPage = Integer.parseInt(reqPage); }

if(reqPage_Size == null || reqPage_Size.equals("")) { pageSize = 10; }
else if(!str_util.isNumeric(reqPage_Size)) pageSize = 1;
else { pageSize = Integer.parseInt(reqPage_Size); }





// -----------------------------------------------------------------------------
// 검색
// -----------------------------------------------------------------------------
String rq_class_cd = "";
String rq_search_type = "-1";
String rq_search_key = "";
String rq_page = "";

String request_str = "";
String request_where_str = "";

rq_class_cd    = str_util.getArgsCheck(request.getParameter("cc"));
rq_page        = str_util.getArgsCheck(request.getParameter("page"));
rq_search_type = str_util.getArgsCheck(request.getParameter("st"));
rq_search_key  = str_util.getArgsCheck(request.getParameter("sk"));

if(rq_page == null || rq_page == "") rq_page = "1";
else if(!str_util.isNumeric(rq_page)) rq_page = "1";

if(rq_class_cd == null || rq_class_cd == "") rq_class_cd = "";
if(rq_search_type == null || rq_search_type == "") rq_search_type = "0";
if(rq_search_key == null || rq_search_key == "") rq_search_key = "";

//XSS 방지
rq_search_key = rq_search_key.replaceAll("%", "");
rq_search_key = rq_search_key.replaceAll("\\*", "");
rq_search_key = rq_search_key.replaceAll("%00", "");
rq_search_key = rq_search_key.replaceAll("null", "");
rq_search_key = rq_search_key.replaceAll("innerHTML", "");
rq_search_key = rq_search_key.replaceAll("javascript", "");
rq_search_key = rq_search_key.replaceAll("eval", "");
rq_search_key = rq_search_key.replaceAll("onmousewheel", "");
rq_search_key = rq_search_key.replaceAll("onactive", "");
rq_search_key = rq_search_key.replaceAll("onfocusout", "");
rq_search_key = rq_search_key.replaceAll("expression", "");
rq_search_key = rq_search_key.replaceAll("charset", "");
rq_search_key = rq_search_key.replaceAll("ondataavailable", "");
rq_search_key = rq_search_key.replaceAll("oncut", "");
rq_search_key = rq_search_key.replaceAll("onkeyup", "");
rq_search_key = rq_search_key.replaceAll("applet", "");
rq_search_key = rq_search_key.replaceAll("documment", "");
rq_search_key = rq_search_key.replaceAll("onafteripudate", "");
rq_search_key = rq_search_key.replaceAll("onclick", "");
rq_search_key = rq_search_key.replaceAll("onkeypress", "");
rq_search_key = rq_search_key.replaceAll("meta", "");
rq_search_key = rq_search_key.replaceAll("string", "");
rq_search_key = rq_search_key.replaceAll("onmousedown", "");
rq_search_key = rq_search_key.replaceAll("onchange", "");
rq_search_key = rq_search_key.replaceAll("onload", "");
rq_search_key = rq_search_key.replaceAll("xml", "");
rq_search_key = rq_search_key.replaceAll("create", "");
rq_search_key = rq_search_key.replaceAll("onbeforeactivate", "");
rq_search_key = rq_search_key.replaceAll("onbeforecut", "");
rq_search_key = rq_search_key.replaceAll("onbounce", "");
rq_search_key = rq_search_key.replaceAll("blink", "");
rq_search_key = rq_search_key.replaceAll("append", "");
rq_search_key = rq_search_key.replaceAll("onbeforecopy", "");
rq_search_key = rq_search_key.replaceAll("onmouseenter", "");
rq_search_key = rq_search_key.replaceAll("ondbclick", "");
rq_search_key = rq_search_key.replaceAll("link", "");
rq_search_key = rq_search_key.replaceAll("binding", "");
rq_search_key = rq_search_key.replaceAll("onbeforedeactivate", "");
rq_search_key = rq_search_key.replaceAll("ondeactivate", "");
rq_search_key = rq_search_key.replaceAll("onmouseout", "");
rq_search_key = rq_search_key.replaceAll("style", "");
rq_search_key = rq_search_key.replaceAll("alert", "");
rq_search_key = rq_search_key.replaceAll("ondatasetchaged", "");
rq_search_key = rq_search_key.replaceAll("ondrag", "");
rq_search_key = rq_search_key.replaceAll("onmouseover", "");
rq_search_key = rq_search_key.replaceAll("script", "");
rq_search_key = rq_search_key.replaceAll("msgbox", "");
rq_search_key = rq_search_key.replaceAll("cnbeforeprint", "");
rq_search_key = rq_search_key.replaceAll("ondragend", "");
rq_search_key = rq_search_key.replaceAll("onsubmit", "");
rq_search_key = rq_search_key.replaceAll("embed", "");
rq_search_key = rq_search_key.replaceAll("refresh", "");
rq_search_key = rq_search_key.replaceAll("cnbeforepaste", "");
rq_search_key = rq_search_key.replaceAll("ondragenter", "");
rq_search_key = rq_search_key.replaceAll("onmouseend", "");
rq_search_key = rq_search_key.replaceAll("object", "");
rq_search_key = rq_search_key.replaceAll("void", "");
rq_search_key = rq_search_key.replaceAll("onbeforeeditfocus", "");
rq_search_key = rq_search_key.replaceAll("ondragleave", "");
rq_search_key = rq_search_key.replaceAll("onresizestart", "");
rq_search_key = rq_search_key.replaceAll("iframe", "");
rq_search_key = rq_search_key.replaceAll("Href", "");
rq_search_key = rq_search_key.replaceAll("onbeforeupdate", "");
rq_search_key = rq_search_key.replaceAll("ondragstart", "");
rq_search_key = rq_search_key.replaceAll("onselectstart", "");
rq_search_key = rq_search_key.replaceAll("frameset", "");
rq_search_key = rq_search_key.replaceAll("onpaste", "");
rq_search_key = rq_search_key.replaceAll("onpropertychange", "");
rq_search_key = rq_search_key.replaceAll("ondrop", "");
rq_search_key = rq_search_key.replaceAll("onreset", "");
rq_search_key = rq_search_key.replaceAll("ilayer", "");
rq_search_key = rq_search_key.replaceAll("onresize", "");
rq_search_key = rq_search_key.replaceAll("ondatasetcomplete", "");
rq_search_key = rq_search_key.replaceAll("onerror", "");
rq_search_key = rq_search_key.replaceAll("onmove", "");
rq_search_key = rq_search_key.replaceAll("layer", "");
rq_search_key = rq_search_key.replaceAll("onselect", "");
rq_search_key = rq_search_key.replaceAll("oncellchange", "");
rq_search_key = rq_search_key.replaceAll("onfinish", "");
rq_search_key = rq_search_key.replaceAll("onstop", "");
rq_search_key = rq_search_key.replaceAll("bgsound", "");
rq_search_key = rq_search_key.replaceAll("base", "");
rq_search_key = rq_search_key.replaceAll("onlayoutcomplete", "");
rq_search_key = rq_search_key.replaceAll("onfocus", "");
rq_search_key = rq_search_key.replaceAll("onrowexit", "");
rq_search_key = rq_search_key.replaceAll("title", "");
rq_search_key = rq_search_key.replaceAll("onblur", "");
rq_search_key = rq_search_key.replaceAll("onselectionchange", "");
rq_search_key = rq_search_key.replaceAll("vbscript", "");
rq_search_key = rq_search_key.replaceAll("onerrorupdate", "");
rq_search_key = rq_search_key.replaceAll("onbefore", "");
rq_search_key = rq_search_key.replaceAll("onstart", "");
rq_search_key = rq_search_key.replaceAll("onrowsinserted", "");
rq_search_key = rq_search_key.replaceAll("onkeydown", "");
rq_search_key = rq_search_key.replaceAll("onfilterchange", "");
rq_search_key = rq_search_key.replaceAll("onmouseup", "");
rq_search_key = rq_search_key.replaceAll("onfocusin", "");
rq_search_key = rq_search_key.replaceAll("oncontrolselected", "");
rq_search_key = rq_search_key.replaceAll("onrowsdelete", "");
rq_search_key = rq_search_key.replaceAll("onlosecapture", "");
rq_search_key = rq_search_key.replaceAll("onrowenter", "");
rq_search_key = rq_search_key.replaceAll("onhelp", "");
rq_search_key = rq_search_key.replaceAll("onreadystatechange", "");
rq_search_key = rq_search_key.replaceAll("Onmouseleave", "");
rq_search_key = rq_search_key.replaceAll("Onmousemove", "");



request_str = "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

req_unify_str = "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;psize=" + pageSize + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");
req_unify_str2 = "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;psize=" + pageSize + "&amp;cc=" + rq_class_cd + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");
req_unify_str3 = "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;cc=" + rq_class_cd + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// DB Connection
// -----------------------------------------------------------------------------
dbset = new DBUtil();


// -----------------------------------------------------------------------------
// 조건식에 의한 SQL문 만들기
// -----------------------------------------------------------------------------

// 게시글 구분
if(rs_inc_bclass.equals("1") && !rq_class_cd.equals(""))
{
  request_where_str = request_where_str + " and bclass = " + rq_class_cd + " ";
}

// 키워드 검색  
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
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// 게시글 개수
// -----------------------------------------------------------------------------

sql = "";
sql = "select count(*) from board ";
sql = sql + "where cid = '" + rq_cid + "' ";

//sql = sql + "and inst_date >= TO_DATE('2013-05-01', 'YYYY-MM-DD') ";

// 답변형 게시판
if(rs_inc_btype.equals("2")) sql = sql + "and blevel = 0 ";

// 글 작성자만 열람
if(rs_inc_bsecret_list.equals("2") && inc_admin.equals("")) sql = sql + "and bu_id = '" + inc_login_id + "' ";

// 휴지통
//if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
sql = sql + "and brecycle = '0' ";

sql = sql + request_where_str;

//out.println(sql);
ResultSet rs_count = stl.executeQuery(sql);

if(rs_count != null)
{
  rs_count.next();
  record_count = rs_count.getInt(1);
}
rs_count.close();
rs_count = null;


totPage = ((record_count - 1) / pageSize) + 1;
lastNum = (curPage - 1) * pageSize;
// ------------------------------------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// 목록구성
// -----------------------------------------------------------------------------

sql = "";

sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, bnotice, btag, bhit, bsecret, brecycle, inst_date, rk, notice_order ";

// 게시글 구분
if(rs_inc_bclass.equals("1")) { sql = sql + ", bclass, bclass_nm "; }

sql = sql + "from ( ";

sql = sql + "select rownum as rnum, b.* from ( ";

sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, bnotice, btag, bhit, bsecret, brecycle, inst_date, rank() over(order by bref asc, bstep desc) as rk, ";

// 공지(게시기간 확인)
sql = sql + "(case when bnotice = '1' and to_char(bnotice_date, 'yyyy-mm-dd') >= to_char(sysdate, 'yyyy-mm-dd') then '1' ";
sql = sql + "when bnotice = '1' and bnotice_date is null then '1' ";
sql = sql + "else '0' end) as notice_order ";


// 게시글 구분
if(rs_inc_bclass.equals("1")) { sql = sql + ", bclass, (select cname from board_class where seqid = a.bclass) bclass_nm "; }

sql = sql + "from board a ";

sql = sql + "where cid = '" + rq_cid + "' ";

//if(rq_cid.equals("101080101000")) sql = sql + "and inst_date >= '2012-10-01' ";
//else sql = sql + "and inst_date >= '2013-10-01' ";

//sql = sql + "and inst_date >= TO_DATE('2013-05-01', 'YYYY-MM-DD') ";


// 답변형 게시판
if(rs_inc_btype.equals("2")) sql = sql + "and blevel = 0 ";

// 글 작성자만 열람
if(rs_inc_bsecret_list.equals("2") && inc_admin.equals("")) sql = sql + "and bu_id = '" + inc_login_id + "' ";

// 휴지통
//if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
sql = sql + "and brecycle = '0' ";

sql = sql + request_where_str;

sql = sql + " order by notice_order desc, bref desc, bstep asc ";

sql = sql + ") b ";
sql = sql + ") a ";
sql = sql + "where a.rnum > " + lastNum + " ";
sql = sql + "and a.rnum <= " + (lastNum + pageSize);


//out.println(sql);
ResultSet rs_list = stl.executeQuery(sql);
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// 게시글 구분
// -----------------------------------------------------------------------------
ResultSet rs_class_list = null;

if(rs_inc_bclass.equals("1")) 
{
  sql = "select seqid, cname from board_class where cid = '" + rq_cid + "' order by cseq";
  rs_class_list = stl.executeQuery(sql);
}
// -----------------------------------------------------------------------------

%>


<script type="text/javascript">
//<![CDATA[

  function fun_view(idx)
  {
    var form = document.board_form;

    form.method.value = "v";
    form.idx.value = idx;

    form.submit();
  }

  function fun_write()
  {
    var form = document.board_form;

    form.method.value = "w";
    form.idx.value = "";
    form.submit();
  }

  function fun_jump(page)
  {
    var form = document.board_form;

    form.method.value = "l";
    form.idx.value = "";
    form.page.value = page;
    form.submit();
  }

  function fun_search()
  {
    var form = document.board_form;
    
    if(form.sk.value == "")
    {
      alert("검색어를 입력 하세요.");
      form.sk.focus();
      return false;
    }
    
    form.method.value = "l";
    form.page.value = "1";
    form.idx.value = "";

    form.submit();
  }
  
  function fun_write_error()
  {
    alert("글쓰기 권한이 없습니다.");
  }
  
  function fun_search_clear()
  {
    var form = document.board_form;
    
    form.method.value = "l";
    form.page.value = "1";
    form.idx.value = "";
    
    form.st.value = "";
    form.sk.value = "";
    
    form.submit();
  }


  function fun_pagesize(val)
  {
    var form = document.board_form;
    form.psize.value = val;
    form.method.value = "l";

    form.submit();

  }
  

//]]>
</script>


<%
// 상위 이미지
if(rs_inc_btitle_img != null && !rs_inc_btitle_img.equals(""))
{
  out.println("<div><img src='/upload/titles/" + rs_inc_btitle_img + "' alt='" + rs_inc_btitle_img_alt + "' /></div>");
}



// -------------------------------------------------------------------------
// 게시글 구분
// -------------------------------------------------------------------------
int rs_class_seqid = 0;
String rs_class_name = "";

if(rs_inc_bclass.equals("1"))
{
  //out.println("<div class='class_tab'>");
  out.println("<div class='theme_menu'>");
  
  out.println("<ul>");
  
  if(rq_class_cd.equals(""))
  {
    out.println("<li><a class='on' href='board.do?" + req_unify_str + "'>전체</a></li>");
  }
  else
  {
    out.println("<li><a href='board.do?" + req_unify_str + "'>전체</a></li>");
  }
  
  if(rs_class_list != null)
  {
    while(rs_class_list.next())
    {
      rs_class_seqid = rs_class_list.getInt(1);
      rs_class_name  = rs_class_list.getString(2);
      
      if(rq_class_cd.equals(rs_class_seqid+""))
      {
        out.println("<li><a class='on' href='board.do?" + req_unify_str + "&amp;cc=" + rs_class_seqid + "'>" + rs_class_name + "</a></li>");
      }
      else
      {
        out.println("<li><a href='board.do?" + req_unify_str + "&amp;cc=" + rs_class_seqid + "'>" + rs_class_name + "</a></li>");
      }
    }
  }
  
  out.println("</ul>");
  
  if(rs_class_list != null) { rs_class_list.close(); rs_class_list = null; }
  
  out.println("</div>");
}
// -------------------------------------------------------------------------
%>

<div class="notice_wrap csize">	
															
	<!-- basic_sch -->
	<div class="sub_cont_inner data_set_box_wrap">
		<div class="data_set_box white_back_box radius_m flex_c_sc">

			<form  class="data_set_2 back_box_inner_title no_title" name="board_form" method="post" action="board.do" onsubmit="return fun_search();" class="inner_box">
				
				<!-- <fieldset class="search_area"> -->
				<!--<legend class="HIDE">검색</legend> -->
				
					<input type="hidden" name="method"    value="" />
					<input type="hidden" name="target"    value="<%=rq_target%>" />
					<input type="hidden" name="cmsid"     value="<%=rq_cid%>" />
					<input type="hidden" name="idx"       value="" />
					<input type="hidden" name="page"      value="<%=rq_page%>" />
					
					<input type="hidden" name="cc"        value="<%=rq_class_cd%>" />
					<input type="hidden" name="psize"     value="<%=pageSize%>" />
				
					<!-- row -->
					<!-- <div class="data_set_2 back_box_inner_title no_title">										 -->
					
						<!-- slt_box -->
						<div class="data_set_serch_box flex_r_cc flex_wrap">
							<!-- <label for="st" class="HIDE">검색범위 선택</label> -->
							<select name="st" size="1" id="st" class="formControl">
								<%
								for(i = 0; i < b_search_type_array.length; i++)
								{
									if(rq_search_type.equals(""+i))
									{
										out.println("<option value='" + i + "' selected='selected'>" + b_search_type_array[i] + "</option>");
									}
									else
									{
										out.println("<option value='" + i + "'>" + b_search_type_array[i] + "</option>");
									}
								}
								%>
							</select>

							<!-- // slt_box -->
							<!-- <label for="sk" class="HIDE">검색어</label> -->
							<input type="search" name="sk" id="sk" value="<%=rq_search_key%>" placeholder="검색어를 입력해주세요." />
			
							<!-- // row -->
							<div class="flex_r_cc search_double_bt">
								<button type="submit" id="search" class="btn_square_blue" title="게시글 검색">검색</button>
								<button type="button" id="all_view" onclick="fun_search_clear();" title="전체게시글 보기">전체보기</button>
							</div>
							
						</div>
					<!-- </div> -->
				<!-- </fieldset> -->
			</form>

		</div>
	</div>
	<!-- // basic_sch -->

		<!-- total / m-->
		<div class="sub_cont_inner data_list_box_wrap flex_c_cs">
			<!-- <div class="inner"> -->
			
				<div class="list_select flex_r_ec border_b_lg">
				 <!--<%
				 String css_page_size_str1 = "";
				 String css_page_size_str2 = "";
				 String css_page_size_str3 = "";
				 
				 if(pageSize == 10) { css_page_size_str1 = "on"; }
				 else if(pageSize == 30) { css_page_size_str2 = "on"; }
				 else if(pageSize == 50) { css_page_size_str3 = "on"; }
				 
				 out.println("<a href='board.do?" + req_unify_str3 + "&psize=10' class='m " + css_page_size_str1 + "'>10개</a>");
				 out.println("<a href='board.do?" + req_unify_str3 + "&psize=30' class='m " + css_page_size_str2 + "'>30개</a>");
				 out.println("<a href='board.do?" + req_unify_str3 + "&psize=50' class='m last " + css_page_size_str3 + "'>50개</a>");
				 %>-->
<!-- 				 <label for="pageSize" class="skip">출력갯수 선택</label> -->
				 <select id="pageSize" onchange="fun_pagesize(this.value)">
					<option value="10" <%if(reqPage_Size.equals("10")) out.println("selected");%>>10개 출력</option>
					<option value="30" <%if(reqPage_Size.equals("30")) out.println("selected");%>>30개 출력</option>
					<option value="50" <%if(reqPage_Size.equals("50")) out.println("selected");%>>50개 출력</option>
				</select>
				
				</div>

				<div class="list_total">
					<P>Total <span><%=record_count%></span> | page <%=curPage%>/<%=totPage%></P>
				</div>

			<!-- </div> -->
			<div class="data_list_box flex_c_es flex_wrap">
				<div class="table_wrap">
	
					<table class="chart_C_basic">
			
			<%-- 			<caption class="HIDE"> --%>
			<%-- 				<strong>${menu_title} 목록</strong> --%>
			<%-- 				<p>${menu_title} 목록 게시물 항목(번호, 제목, 작성자, 작성일, 조회 등)를 볼수 있고 제목 링크를 통해서 게시물 상세 내용으로 이동합니다.</p> --%>
			<%-- 			</caption> --%>
			
						<thead>
			
						<%
						// 답변형 게시판
						if(rs_inc_btype.equals("2"))
						{
							if(!rs_inc_bclass.equals("1"))
							{
								out.println("<tr>");
								out.println("  <th scope='col' class='bt_num' width='8%'>번호</th>");
								out.println("  <th scope='col' width='54%'>제목</th>");
								out.println("  <th scope='col' class='bt_open' width='8%'>공개</th>");
								out.println("  <th scope='col' class='bt_name' width='8%'>작성자</th>");
								out.println("  <th scope='col' class='bt_date' width='14%'>작성일</th>");
								out.println("  <th scope='col' class='bt_sit'  width='10%'>상태</th>");
								out.println("</tr>");
							}
							else
							{
								out.println("<tr>");
								out.println("  <th scope='col' class='bt_num' style='width:8%;'>번호</th>");
								out.println("  <th scope='col' style='width:10%;'>구분</th>");
								out.println("  <th scope='col' style='width:34%;'>제목</th>");
								out.println("  <th scope='col' lass='bt_open' >공개</th>");
								out.println("  <th scope='col' class='bt_name' style='width:18%;'>작성자</th>");
								out.println("  <th scope='col' class='bt_date' style='width:15%;'>작성일</th>");
								out.println("  <th scope='col' class='bt_sit' style='width:8%;'>상태</th>");
								out.println("</tr>");
							}
						}
						// 공지형, 일반형 게시판
						else
						{
							if(!rs_inc_bclass.equals("1"))
							{
								out.println("<tr>");
								out.println("  <th scope='col' class='bt_num' style='width:8%;'>번호</th>");
						if(rq_cid.equals("101050200000") || rq_cid.equals("101050400000") || rq_cid.equals("101050300000") || rq_cid.equals("101050100000") || rq_cid.equals("101090400004") || rq_cid.equals("101050600000"))
								 out.println("  <th scope='col' style='width:66%;'>제목</th>");
						else
						 out.println("  <th scope='col' style='width:48%;'>제목</th>");
								out.println("  <th scope='col' class='bt_file' style='width:6%;'>첨부</th>");
						if(rq_cid.equals("101050200000") || rq_cid.equals("101050400000") || rq_cid.equals("101050300000") || rq_cid.equals("101050100000") || rq_cid.equals("101090400004") || rq_cid.equals("101050600000"))
							{/*out.println("  <th scope='col' class='bt_name' style='width:18%;'>작성자</th>");*/}
						else
						 out.println("  <th scope='col' class='bt_name' style='width:18%;'>작성자</th>");
								out.println("  <th scope='col' class='bt_date' style='width:15%;'>작성일</th>");
								out.println("  <th scope='col' class='bt_count' style='width:8%;'>조회</th>");
								out.println("</tr>");
							}
							else
							{
								out.println("<tr class='first_line'>");
								out.println("  <th scope='col' class='bt_num' style='width:8%;'>번호</th>");
								out.println("  <th scope='col' style='width:15%;'>구분</th>");
						if(rq_cid.equals("101050200000") || rq_cid.equals("101050400000") || rq_cid.equals("101050300000") || rq_cid.equals("101050100000") || rq_cid.equals("101090400004") || rq_cid.equals("101050600000"))
								 out.println("  <th scope='col' style='width:54%;'>제목</th>");
						else
							 out.println("  <th scope='col' style='width:36%;'>제목</th>");
								out.println("  <th scope='col' class='bt_file' style='width:6%;'>첨부</th>");
						 if(rq_cid.equals("101050200000") || rq_cid.equals("101050400000") || rq_cid.equals("101050300000") || rq_cid.equals("101050100000") || rq_cid.equals("101090400004") || rq_cid.equals("101050600000"))
									{/*out.println("  <th scope='col' class='bt_name' style='width:18%;'>작성자</th>");*/}
						 else
						 out.println("  <th scope='col' class='bt_name' style='width:18%;'>작성자</th>");
								out.println("  <th scope='col' class='bt_date' style='width:15%;'>작성일</th>");
								out.println("  <th scope='col' class='bt_count' style='width:8%;'>조회</th>");
								out.println("</tr>");
							}
						}
			
						out.println("</thead>");
			
						out.println("<tbody>");
			
						
			
						if(record_count > 0)
						{
							while(rs_list.next())
							{
								i = 1;
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
								//rs_bnotice     = rs_list.getString(13);
								rs_btag        = rs_list.getString(14);
								rs_bhit        = rs_list.getInt(15);
								rs_bsecret     = rs_list.getString(16);
								rs_brecycle    = rs_list.getString(17);
								rs_inst_date   = rs_list.getDate(18);
								rs_rank        = rs_list.getInt(19);
								rs_bnotice     = rs_list.getString(20);
								
								if(rs_inc_bclass.equals("1"))
								{
									i++;
									rs_bclass_nm = rs_list.getString(21);
									if(rs_bclass_nm == null) { rs_bclass_nm = ""; }
								}
								
								if(rs_bu_dept_nm == null) { rs_bu_dept_nm = ""; }
								//if(rs_bu_dept_oclass_nm == null) { rs_bu_dept_oclass_nm = ""; }
								//if(rs_bu_dept_par_nm == null) { rs_bu_dept_par_nm = ""; }
								
								/*
								if((rs_bu_dept_oclass_nm.equals("지역교육청") || rs_bu_dept_oclass_nm.equals("직속기관")) && !rs_bu_dept_par_nm.equals(""))
								{
									rs_bu_dept_nm = rs_bu_dept_par_nm;
								}
								else if(rs_bu_dept_nm.equals("")) { rs_bu_dept_nm = rs_bu_name; }
								*/
								
								if(rs_bu_dept_nm.equals("")) { rs_bu_dept_nm = rs_bu_name; }
								
								if(!rs_bsubject.equals(""))
								{
									if(rq_cid.equals("101050200000") || rq_cid.equals("101050400000") || rq_cid.equals("101050300000") || rq_cid.equals("101050100000") || rq_cid.equals("101090400004") || rq_cid.equals("101050600000"))
							{
								if(rs_bsubject.length() > 45) rs_bsubject_shot = rs_bsubject.substring(0, 42) + "...";
								else rs_bsubject_shot = rs_bsubject;
							}
							else
							{
								if(rs_bsubject.length() > 30) rs_bsubject_shot = rs_bsubject.substring(0, 27) + "...";
								else rs_bsubject_shot = rs_bsubject;
							}
								}
								
								// ---------------------------------------------------------
								// 글 공개 여부
								// ---------------------------------------------------------
								if(rs_inc_bsecret_view.equals("0")) { secret_tag = "<em class='public_1'>공개</em>"; }
								else if(rs_inc_bsecret_view.equals("3")) { secret_tag = "<em class='public_1'>공개</em>"; rs_bu_name = "***"; }
								else if(rs_inc_bsecret_view.equals("2")) { secret_tag = "<em class='public_0'>비공개</em>"; rs_bu_name = "***"; }
								else if(rs_inc_bsecret_view.equals("1"))
								{
									if(rs_bsecret.equals("0")) secret_tag = "<em class='public_1'>공개</em>";
									else if(rs_bsecret.equals("1")) { secret_tag = "<em class='public_0'>비공개</em>"; rs_bu_name = "***"; }
								}
								// ---------------------------------------------------------
								
								// ---------------------------------------------------------
								// 접수/답변
								// ---------------------------------------------------------
								state_tag = "<em class='finish_0'>접수</em>";
								sql = "select count(*) from board where cid = '" + rq_cid + "' and bref = " + rs_seqid + " and blevel = 1 and bstep = 1 ";
								// 휴지통
								//if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
								sql = sql + "and brecycle = '0' ";
								
								ResultSet rs_list_a = stl.executeQuery(sql);
								if(rs_list_a.next())
								{
									if(rs_list_a.getInt(1) > 0) state_tag = "<em class='finish_1'>완료</em>";
								}
								rs_list_a.close();
								// ---------------------------------------------------------------------
								
								// ---------------------------------------------------------------------
								// 첨부파일
								// ---------------------------------------------------------------------
								
								sql = "select fname_o from board_file where cid = ? and bseqid = ? and freg = '1' and rownum = 1 order by seqid asc ";
								
								dbset.setQuery(sql);
								
								i = 1;
								dbset.setString(i++, rq_cid);
								dbset.setInt(i++, rs_seqid);
								
								int file_pos = 0;
								String file_full = "";
								String file_ext = "";
								
								rs_file_list = dbset.executeQuery();
								
								files_img = "";
								
								while(rs_file_list.next())
								{
									file_full = rs_file_list.getString(1);
									
									if(file_full != null && !file_full.equals(""))
												{
										file_pos  = file_full.lastIndexOf(".");           // 확장자
										file_ext  = file_full.substring(file_pos + 1);
										
										if(file_ext.equals("hwp")) { files_img = files_img + "<img src='images/file/hwp.gif' alt='한글파일' width='16' height='16' border='0' />"; }
										else if(file_ext.equals("hwp")) { files_img = files_img + "<img src='images/file/hwp.gif' alt='한글파일' width='16' height='16' border='0' />"; }
										else if(file_ext.equals("pdf")) { files_img = files_img + "<img src='images/file/pdf.gif' alt='PDF파일' width='16' height='16' border='0' />"; }
												 else if(file_ext.equals("ppt") || file_ext.equals("pptx")) { files_img = files_img + "<img src='images/file/ppt.gif' alt='액셀파일' width='16' height='16' border='0' />"; }
										else if(file_ext.equals("doc") || file_ext.equals("docx")) { files_img = files_img + "<img src='images/file/docx.gif' alt='워드파일' width='16' height='16' border='0' />"; }
										else if(file_ext.equals("ai")) { files_img = files_img + "<img src='images/file/ai.gif' alt='일러스트파일' width='16' height='16' border='0' />"; }
			
										else if(file_ext.equals("xls") || file_ext.equals("xlsx")) { files_img = files_img + "<img src='images/file/xls.gif' alt='액셀파일' width='16' height='16' border='0' />"; }
										else if(file_ext.equals("zip") || file_ext.equals("arj") || file_ext.equals("alz") || file_ext.equals("rar") || file_ext.equals("egg ")) { files_img = files_img + "<img src='images/file/zip.gif' alt='압축파일' width='16' height='16' border='0' />"; }
										else if(file_ext.equals("jpg") || file_ext.equals("JPG")) { files_img = files_img + "<img src='images/file/jpg.gif' alt='이미지파일' width='15' height='16' border='0' />"; }
										else if(file_ext.equals("png") || file_ext.equals("PNG")) { files_img = files_img + "<img src='images/file/png.gif' alt='이미지파일' width='15' height='16' border='0' />"; }
										else if(file_ext.equals("gif") || file_ext.equals("GIF")) { files_img = files_img + "<img src='images/file/gif.gif' alt='이미지파일' width='15' height='16' border='0' />"; }
										else if(file_ext.equals("wmv") || file_ext.equals("mp4") || file_ext.equals("avi") || file_ext.equals("mov")) { files_img = files_img + "<img src='images/file/wmv.gif' alt='동영상파일' width='16' height='16' border='0' />"; }
										else { files_img = files_img + "<img src='images/file/file.gif' alt='첨부파일' width='16' height='16' border='0' />"; }
									}  
								}
								
								if (rs_file_list != null) { rs_file_list.close(); rs_file_list = null; }
								
								// ---------------------------------------------------------------------
								
								//rs_bsubject = "<a href='javascript:fun_view(" + rs_seqid + ");' alt='" + rs_bsubject + "'>" + rs_bsubject_shot + "</a>";
								rs_bsubject = "<a href='board.do?" + req_unify_str2 + "&amp;method=v&amp;idx=" + rs_seqid + "&amp;page=" + rq_page + "' alt='" + rs_bsubject + "' title='" + rs_bsubject + "'>" + rs_bsubject_shot + "</a>";
								
								
								if(rs_inc_btype.equals("2"))
								{
									out.println("<tr>");
			
									if(rs_brecycle.equals("1")) { out.println("  <td class='bt_num'>삭제</td>"); }
									else if(rs_bnotice.equals("1")) { out.println("  <td class='bt_num'>공지</td>"); }
									else { out.println("  <td class='bt_num'>" + rs_rank + "</td>"); }
			
									if(rs_inc_bclass.equals("1")) { out.println("  <td class='bt_num'>" + rs_bclass_nm + "</td>"); }
			
									out.println("  <td class='tl tit'>" + rs_bsubject + "</td>");
									out.println("  <td>" + secret_tag + "</td>");
									out.println("  <td class='bt_name'>" + rs_bu_name + "</td>");
									out.println("  <td class='bt_date'>" + rs_inst_date + "</td>");
									out.println("  <td class='bt_sit'>" + state_tag + "</td>");
									out.println("</tr>");
								}
								else
								{
									out.println("<tr>");
			
									if(rs_brecycle.equals("1")) { out.println("  <td class='bt_num'>삭제</td>"); }
									else if(rs_bnotice.equals("1")) { out.println("  <td class='bt_num'>공지</td>"); }
									else { out.println("  <td class='bt_num'>" + rs_rank + "</td>"); }
			
									if(rs_inc_bclass.equals("1")) { out.println("  <td class='tit'>" + rs_bclass_nm + "</td>"); }
			
									out.println("  <td class='tl tit'>" + rs_bsubject + "</td>");
									out.println("  <td class='bt_file'>" + files_img + "</td>");
							if(rq_cid.equals("101050200000") || rq_cid.equals("101050400000") || rq_cid.equals("101050300000") || rq_cid.equals("101050100000") || rq_cid.equals("101090400004") || rq_cid.equals("101050600000"))
							{/*out.println("  <td class='bt_name'>" + rs_bu_name + "</td>");*/}
							else
									 out.println("  <td class='bt_name'>" + rs_bu_name + "</td>");
									out.println("  <td class='bt_date'>" + rs_inst_date + "</td>");
									out.println("  <td class='bt_count'>" + rs_bhit + "</td>");
									out.println("</tr>");
								}
							}
							
							
							rs_list.close();
							rs_list = null;
						}
						else
						{
							if(rs_inc_btype.equals("2"))
							{
								if(rs_inc_bclass.equals("1")) out.println("<tr><td colspan='7'>등록된 내용이 없습니다.</td></tr>");
								else out.println("<tr><td colspan='6'>등록된 내용이 없습니다.</td></tr>");
							}
							else
							{
								if(rs_inc_bclass.equals("1")) out.println("<tr><td colspan='7'>등록된 내용이 없습니다.</td></tr>");
								else out.println("<tr><td colspan='6'>등록된 내용이 없습니다.</td></tr>");
							}
						}
						%>
						</tbody>
						
						</table>
						
				</div>
				<%
				
	// 			out.println("<a href='login/loginForm.do?url=/main/board.do?cmsid=101010300000&target=&psize=10&cc=&st=0&sk='>테스트버튼")</a>;
				
				// 글쓰기 버튼
				if(rs_inc_aw.equals("1"))
				{
					out.println("<a class='btn_square_line' href='board.do?" + req_unify_str2 + "&amp;method=w&amp;idx=&amp;page=1'  ><span>글쓰기</span></a>");
				}
				else if(!rs_inc_btype.equals("0"))
				{
					if(session.getAttribute("session_login_id") == null)
					{
						out.println("<a  class='btn_square_line'href='/login/loginForm.do?url=/main/board.do?" + req_unify_str2 + "'  ><span>글쓰기</span></a>");
					}
					else
					{
						out.println("<a  class='btn_square_line'href='#msg'  onclick='fun_write_error();'><span>글쓰기</span></a></div>");
					}
				}
				%>
			</div>
	
				
				<div class="sub_paging_wrap flex_r_cc">
					 <ul class="sub_pasing_box flex_r_cc">
	
						<%
	
						intStart = ((curPage - 1) / intNumOfPage) * intNumOfPage + 1;
						intEnd = (((curPage - 1) + intNumOfPage) / intNumOfPage) * intNumOfPage;
	
						if(totPage <= intEnd)
						{
							 intEnd = totPage;
						}
	
						if(curPage > intNumOfPage)
						{
							// 첫페이지로
							out.println("<li class='first_pg_bt pg_bt'><a href='board.do?" + req_unify_str2 + "&amp;method=l&amp;idx=&amp;page=1' title='첫페이지 이동'><span style='display: none'>첫 페이지 이동</span></a></li>");
	
							// 이전10개페이지보여주기
							out.println("<li class='prev_pg_bt pg_bt'><a href='board.do?" + req_unify_str2 + "&amp;method=l&amp;idx=&amp;page=" + (intStart - intNumOfPage) + "' title='이전 페이지 이동'><span style='display: none'>이전 페이지 이동</span></a></li>");
						}
						else
						{
							out.println("<li class='first_pg_bt pg_bt'><a href='#first' title='첫페이지 이동'><span style='display: none'>첫 페이지 이동</span></a></li>");
							out.println("<li class='prev_pg_bt pg_bt'><a href='#previ' title='이전 페이지 이동'><span style='display: none'>이전 페이지 이동</span></a></li>");
						}
	
						for(i = intStart; i <= intEnd; i++)
						{
							if(i == curPage)
							{
								out.println("<li class='paging_number_li'><a href='#" + i + "' class='active'>" + i + "</a></li>");
							}
							else
							{
								out.println("<li class=''> <a href='board.do?" + req_unify_str2 + "&amp;method=l&amp;idx=&amp;page=" + i + "'>" + i + "</a></li>");
							}
						}
	
						if(totPage > intEnd)
						{
							// 다음10개페이지로
							out.println("<li class='next_pg_bt pg_bt'><a href='board.do?" + req_unify_str2 + "&amp;method=l&amp;idx=&amp;page=" + (intEnd + 1) + "' title='다음 페이지 이동'><span style='display: none'>다음 페이지 이동</span></a></li>");
	
							// 마지막페이지로
							out.println("<li class='last_pg_bt pg_bt'><a href='board.do?" + req_unify_str2 + "&amp;method=l&amp;idx=&amp;page=" + totPage + "' title='마지막 페이지 이동'><span style='display: none'>마지막 페이지 이동</span></a></li>");
						}
						else
						{
							out.println("<li class='next_pg_bt pg_bt'><a href='#next' title='다음 페이지 이동'><span style='display: none'>다음 페이지 이동</span></a></li>");
							out.println("<li class='last_pg_bt pg_bt'><a href='#last' title='마지막 페이지 이동'><span style='display: none'>마지막 페이지 이동</span></a></li>");
						}
	
						%>
						</ul>
				</div>
		</div>






</div>
<!-- // notice_wrap -->

<%
}
else
{
  if(rs_inc_bsecret_list != null && (rs_inc_bsecret_list.equals("1") || rs_inc_bsecret_list.equals("2")))
  {
    
    if(rs_inc_blogin_img != null && !rs_inc_blogin_img.equals(""))
    {
      out.println("<div align='center'><img src='/upload/titles/" + rs_inc_blogin_img + "'  alt='" + rs_inc_blogin_img_alt + "' /></div>");
    }
    %>
    
    <div class="con_box">
     <dl> 
     	<dt class="tc"><span class="blue">회원가입</span> 후 <span class="blue">로그인</span>을 하여 이용하실 수 있습니다.<br> 아래 버튼을 누르시면 로그인창으로 이동합니다.</dt>
      <!--div style='text-align:center'><a href='/login/loginForm.jbe?url=<%=url_context_path%>/board.jbe?cmsid=<%=inc_rq_cid%>'>로그인(Login)</a></div-->
      <dd class="tc mt_20"><a href='${loginUrl}' class="btn_app" title="로그인(Login)">로그인(Login)</a></dd>
     </dl>
	   </div>
    
    <%
    //out.println("  <br/><br/>");
    //out.println("  <div align='center'>로그인이 필요 합니다.</div>");
    //out.println("  <br/><br/>");
    //out.println("  <div align='center'><a href='/login/loginForm.jbe?url=/main/board.jbe?cmsid=" + inc_rq_cid + "'>로그인(Login)</a></div>");
    
  }
  else
  {
    if(dbset != null) { dbset.close(); dbset = null; }
    if(stl!=null) { stl.close(); stl = null; }

    out.println("<script language='JavaScript'>");
    out.println("<!--");
    out.println("  alert('게시판 목록을 볼 수 있는 권한이 없거나, 별도의 인증(로그인)이 필요한 게시판 입니다.');");
    out.println("  history.back();");
    out.println("-->");
    out.println("</script>");
  }


}


if (dbset != null) { dbset.close(); dbset = null; }

if(stl!=null)
{
  stl.close();
  stl = null;
}

%>
