<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%@ page import="java.text.SimpleDateFormat, java.util.Calendar, java.util.Date" %>
<%@ page import="java.text.*" %>

<jsp:useBean id="stl"      class="goodit.common.dao.DBUtil"      scope="page"/>
<jsp:useBean id="str_util" class="goodit.common.util.StringUtil" scope="page"/>

<%@ include file="board_control.jsp" %>

<%

// -----------------------------------------------------------------------------
// 변수선언
// -----------------------------------------------------------------------------


String[] tag_array = {"TEXT", "HTML", "HTML+BR"};
String[] secret_array = {"공개글", "비밀글"};

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
int rs_bclass = 0;

int rs_class_seqid = 0;

String rs_cid = "";
String rs_bclass_nm = "";
String rs_bu_name = "";
String rs_bnotice = "";
String rs_bu_email = "";
String rs_bu_pwd = "";
String rs_bsubject = "";
String rs_bcontent = "";
String rs_btag = "";
String rs_bsecret = "";
String rs_inst_date = "";

String rs_class_name = "";


// Request
String req_unify_str = "";

String rq_cid = "";
String rq_method = "";
String rq_target = "";
String rq_idx = "";


String rq_bref = "";
String rq_bstep = "";
String rq_blevel = "";



rq_cid    = request.getParameter("cmsid");
rq_method = request.getParameter("method");
rq_target = request.getParameter("target");
rq_idx    = request.getParameter("idx");

rq_bref   = request.getParameter("b_ref");
rq_bstep  = request.getParameter("b_step");
rq_blevel = request.getParameter("b_level");

if(rq_cid == null) rq_cid = "";
if(rq_idx == null) rq_idx = "";
if(rq_bref == null) rq_bref = "";
if(rq_bstep == null) rq_bstep = "";
if(rq_blevel == null) rq_blevel = "";

if(rq_target == null || rq_target.equals("")) rq_target = "";

if("".equals(rq_cid) || "".equals(rq_idx)) 
{  
  if(stl!=null) { stl.close(); stl = null; }
  //out.println("<div id='wrap'>입력항목에 문제가 있습니다.</div>");
  
  String message_url = "/main/messagebox.action?cmsid=" + rq_cid + "&url=/&msg=" + URLEncoder.encode("잘못된 경로에 접근하셨습니다.", "UTF-8");
  
  out.println("<script type=\"text/javascript\">");
  out.println("//<![CDATA[");
  out.println("document.location.href = \"" + message_url + "\";");
  out.println("//]]>");
  out.println("</script>");
  
  return;
}


// -----------------------------------------------------------------------------
// 검색
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// 수정 권한이 있는지 체크
// -----------------------------------------------------------------------------
if(rs_inc_am.equals("1") || rs_inc_am_r.equals("1"))
{


sql = "";
sql = sql + "select seqid, cid, bno, bu_seqid, bu_name,  bu_email, bu_pwd, bref, blevel, bstep, ";
sql = sql + "bnotice,  ";
sql = sql + "bsubject, bcontent, btag, bsecret, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') ";

// 게시글 구분
if(rs_inc_bclass.equals("1")) { sql = sql + ", bclass, (select cname from board_class where seqid = a.bclass) bclass_nm "; }

sql = sql + "from board a ";
sql = sql + "where cid = '" + rq_cid + "' and seqid = " + rq_idx + " ";

// 휴지통
//if(inc_admin.equals("")) sql = sql + "and brecycle = '0' ";
sql = sql + "and brecycle = '0' ";

ResultSet rs_list = stl.executeQuery(sql);

if(rs_list.next())
{
  i = 1;
  rs_seqid       = rs_list.getInt(i++);
  rs_cid         = rs_list.getString(i++);
  rs_no          = rs_list.getInt(i++);
  rs_bu_seqid    = rs_list.getInt(i++);
  rs_bu_name     = rs_list.getString(i++);
  rs_bu_email    = rs_list.getString(i++);
  rs_bu_pwd      = rs_list.getString(i++);
  rs_bref        = rs_list.getInt(i++);
  rs_blevel      = rs_list.getInt(i++);
  rs_bstep       = rs_list.getInt(i++);
  

  rs_bnotice      = rs_list.getString(i++);
  
  rs_bsubject    = rs_list.getString(i++);
  i++;
  rs_bcontent    = stl.getClobToString(rs_list, "bcontent");
  
  rs_btag        = rs_list.getString(i++);
  rs_bsecret     = rs_list.getString(i++);
  rs_bhit        = rs_list.getInt(i++);
  rs_inst_date   = rs_list.getString(i++);

  
  
  // 구분
  if(rs_inc_bclass.equals("1"))
  {
    rs_bclass    = rs_list.getInt(i++);
    rs_bclass_nm = rs_list.getString(i++);
    if(rs_bclass_nm == null) { rs_bclass_nm = ""; }
  }
}

// -----------------------------------------------------------------------------
// 게시글 구분
// -----------------------------------------------------------------------------
ResultSet rs_class_list = null;

if(rs_inc_bclass.equals("1")) 
{
  sql = "select seqid, cname from board_class where cid = '" + rq_cid + "' order by cseq";
  rs_class_list = stl.executeQuery(sql);
}


%>

<link type="text/css" href="css/jquery-ui.css" rel="stylesheet" />

<style type="text/css">
<!--
.ui-datepicker { font:12px dotum; }
.ui-datepicker select.ui-datepicker-month, 
.ui-datepicker select.ui-datepicker-year { width: 70px;}
.ui-datepicker-trigger { margin:0 0 -5px 2px; }
-->
</style>

<script type="text/javascript" src="board/ckeditor/ckeditor.js"></script>

<script type="text/javascript" src="js/jquery-ui.min.js"></script>

<script type="text/javascript">
//<![CDATA[


jQuery(function($){

  $.datepicker.regional['ko'] = {
    closeText: '닫기',
    prevText: '이전달',
    nextText: '다음달',
    currentText: '오늘',
    monthNames: ['1월(JAN)','2월(FEB)','3월(MAR)','4월(APR)','5월(MAY)','6월(JUN)','7월(JUL)','8월(AUG)','9월(SEP)','10월(OCT)','11월(NOV)','12월(DEC)'],
    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
    dayNames: ['일','월','화','수','목','금','토'],
    dayNamesShort: ['일','월','화','수','목','금','토'],
    dayNamesMin: ['일','월','화','수','목','금','토'],
    weekHeader: 'Wk',
    dateFormat: 'yy-mm-dd',
    firstDay: 0,
    isRTL: false,
    showMonthAfterYear: true,
    yearSuffix: ''};
    
  $.datepicker.setDefaults($.datepicker.regional['ko']);
  
  
  $('#b_notice_date').datepicker({
    showOn: 'button',
    buttonImage: 'images/calendar.gif', // 달력 아이콘 이미지 경로
    buttonImageOnly: true,
    buttonText: "달력",
    changeMonth: true,
    changeYear: true,
    showButtonPanel:true
    //yearRange: 'c-99:c+99',
    //maxDate: '+0d'
  });
     
});


function fun_send_form()
{
  var form = document.board_form;
  
  <%
  if(rs_inc_bu_id.equals("") && inc_admin.equals(""))
  {
  %>
  
  if (form.bu_pwd.value=="")
  { 
     alert("\n비밀번호를 입력하세요.");
     form.bu_pwd.focus();
     return;
  }
  
  <%
  }
  
  // 구분
  if(rs_inc_bclass.equals("1"))
  {
  %>
  
  if (form.b_class.value == "")
  { 
     alert("\n구분을 선택하세요.");
     form.b_class.focus();
     return;
  }
  
  <%
  }
  %>
  
  if (form.b_subject.value=="")
  { 
     alert("\n제목을 입력하세요.");
     form.b_subject.focus();
     return;
  }
  

  
  if (form.b_content.value=="")
  { 
     alert("\n내용을 입력하세요.");
     form.b_content.focus();
     return;
  }
  
  
  <%
  if(rs_inc_bfile.equals("1") && rq_idx.equals(""))
  {
  %>
  if(document.getElementById("insertFileWin") != null)
  {
    var form_iframe = document.getElementById("insertFileWin").contentWindow.document.fileForm;
    
    if (form_iframe.filename.value != "")
    { 
      alert("\n첨부 파일이 있는지 확인해 주세요. \n(저장 전에 첨부 버튼을 먼저 선택하셔야 합니다.)");
      form_iframe.filename.focus();
      return;
    }
  }
  <%
  }
  %>
  
  
  form.mode.value = 1;
  form.submit();
}
    
//]]>
</script>




    
<form name="board_form" method="post" action="board/board_update.jsp" >

<input type="hidden" name="target"    value="<%=rq_target%>" />
<input type="hidden" name="cmsid"     value="<%=rq_cid%>" />
<input type="hidden" name="idx"       value="<%=rq_idx%>" />
<input type="hidden" name="mode"      value="" />

<input type="hidden" name="cc"        value="<%=rq_class_cd%>" />
<input type="hidden" name="psize"     value="<%=rq_page_size%>" />
<input type="hidden" name="page"      value="<%=rq_page%>" />
<input type="hidden" name="st"        value="<%=rq_search_type%>" />
<input type="hidden" name="sk"        value="<%=rq_search_key%>" />

<input type="hidden" name="b_ref"     value="<%=rq_bref%>" />
<input type="hidden" name="b_step"    value="<%=rq_bstep%>" />
<input type="hidden" name="b_level"   value="<%=rq_blevel%>" />


<table class="basic_table" summary="${menu_title}의 게시물 내용을 글수정을 할 수 있도록 나타내고 있습니다.">
  
	<caption class="HIDE">
			<strong>${menu_title} 글수정</strong>
			<p>${menu_title}의 글수정 항목(작성자, 비밀번호, 이메일, 전화번호, 휴대폰, 주소, 내용, 첨부파일등) 내용을 글수정을 할 수 있도록 나타내고 있습니다.</p>
		</caption>
  
  <%
  if(rs_inc_bu_id.equals("") && inc_admin.equals(""))
  {
  %>
  
  <tr class="first_line">
    <th scope="row" class="first_cell" width="20%" class="left">작성자</th>
    <td>&nbsp;&nbsp;<%=rs_bu_name%></td>
  </tr>
  
  <tr>
    <th scope="row" width="20%" ><label for="bu_pwd" class="left">비밀번호</label></th>
    <td><input type="password" name="bu_pwd" size="25" maxlength="15" value="" id="bu_pwd"></td>
  </tr>
  
  <%
  }
  else
  {
  %>
  
  <tr class="first_line">
    <th scope="row" width="20%" class="left">작성자</th>
    <td><%=rs_bu_name%></td>
  </tr>
  <%
  }
  
  
  
  
  // 구분
  if(rs_inc_bclass.equals("1") && rs_blevel == 0)
  {
  %>
  
  <tr>
    <th scope="row" width="20%" class="left"><label for="b_class">구분</label></th>
    <td>
        <select name="b_class" id="b_class" size="1">
        <option value=''>구분선택</option>
        <%
        while(rs_class_list.next())
        {
          rs_class_seqid = rs_class_list.getInt(1);
          rs_class_name  = rs_class_list.getString(2);
          
          if(rs_bclass == rs_class_seqid)
          {
            out.println("<option value='" + rs_class_seqid + "' selected='selected'>" + rs_class_name + "</option>");
          }
          else
          {
            out.println("<option value='" + rs_class_seqid + "'>" + rs_class_name + "</option>");
          }
        }
        
        rs_class_list.close();
        rs_class_list = null;
        %>
        
        </select>
    </td>
  </tr>
  
  <%
  }
  %>
  
  <tr>
    <th scope="row" width="20%" class="left"><label for="b_subject">제목</label></th>
    <td><input type="text" id="b_subject" name="b_subject" style="width:100%;" maxlength="255" value="<%=rs_bsubject%>" /></td>
  </tr>
  
<%
  
  // 공지
  if(!inc_admin.equals("") || inc_login_class.equals("jbe_office"))
  {
  %>
  
  <tr>
    <th scope="row" width="20%" class="left"><label for="b_notice">공지</label></th>
    <td>
      <input type="checkbox" id="b_notice" name="b_notice" value="1" <% if(rs_bnotice.equals("1")) { out.print("checked"); } %> />
      체크박스 선택과 게시 기간을 입력하면 공지로 게시
    </td>
  </tr>
  
  <%
  }
  
  if(rs_inc_bsecret_view.equals("1") && rs_blevel == 0 && rs_bstep == 0)
  {
  %>
  <tr>
    <th scope="row" width="20%" class="left"><label for="b_secret">비밀글</label></th>
    <td>
        <select id="b_secret" name="b_secret" size="1">
        <%
        for(i = 0; i < secret_array.length; i++)
        {
          if(rs_bsecret.equals(""+i))
          {
            out.println("<option value='" + i + "' selected>" + secret_array[i] + "</option>");
          }
          else
          {
            out.println("<option value='" + i + "'>" + secret_array[i] + "</option>");
          }
        }
        %>
        </select>
    </td>
  </tr>
  <%
  }
  %>
  
  <tr>
    <th scope="row" width="20%" class="left"><label for="b_content">내용</label></th>
    <td><textarea id="b_content" name="b_content" rows="20"  style="width:100%;"><%=rs_bcontent%></textarea></td>
  </tr>
  <%
  if(rs_inc_bfile.equals("1") && rs_blevel == 0 && rs_bstep == 0)
  {
  %>
  <tr>
    <th scope="row" width="20%" class="left">첨부파일</th>
    <td><iframe id="insertFileWin" width="480" height="120" src="/upload/upload_form.jsp?cid=<%=rq_cid%>&amp;sid=<%=session.getId()%>&amp;seqid=<%=rs_seqid%>" scrolling="no" frameborder="0" title="첨부파일 목록"></iframe></td>
  </tr>
  <%
  }
  %>
</table>

<div class="b_button tc">
  <a class="typeA" href="#fun_send_form" onclick="fun_send_form(); return false;">수정</a>
  <a class="typeB" href="board.do?<%=req_unify_str%>&amp;method=v&amp;idx=<%=rs_bref%>&amp;page=<%=rq_page%>">취소</a>
</div>
    
</form>



<%
}

// -----------------------------------------------------------------------------
// 수정 권한이 없을때 처리
// -----------------------------------------------------------------------------
else
{
  if(stl!=null) { stl.close(); stl = null; }

  out.println("<form name='board_form' method='post' action='board.do'>");
  
  out.println("<input type='hidden' name='method'    value=''>");
  out.println("<input type='hidden' name='target'    value='" + rq_target + "'>");
  out.println("<input type='hidden' name='cmsid'     value='" + rq_cid + "'>");
  out.println("<input type='hidden' name='mode'      value=''>");
  
  out.println("<input type='hidden' name='cc'        value='" + rq_class_cd + "'>");
  out.println("<input type='hidden' name='psize'     value='" + rq_page_size + "'>");
  out.println("<input type='hidden' name='page'      value='" + rq_page + "'>");
  out.println("<input type='hidden' name='st'        value='" + rq_search_type + "'>");
  out.println("<input type='hidden' name='sk'        value='" + rq_search_key + "'>");
  
  out.println("</form>");
  
  out.println("<script language='JavaScript'>");
  out.println("<!--");
  out.println("  var form = document.board_form;");
  out.println("  alert('게시판 글수정 권한이 없거나, 별도의 인증(로그인)이 필요한 게시판 입니다.');");
  out.println("  form.method.value = 'l';");
  out.println("  form.submit();");
  out.println("-->");
  out.println("</script>");
}

if(stl != null)
{ 
 	stl.close(); 
	 stl = null;
}

%>