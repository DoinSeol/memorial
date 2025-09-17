<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>

<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Calendar, java.util.Date" %>

<%@ page import="goodit.common.dao.*"%>

<jsp:useBean id="stl"      class="goodit.common.dao.DBUtil"      scope="page"/>
<jsp:useBean id="str_util" class="goodit.common.util.StringUtil" scope="page"/>

<%@ include file="board_control.jsp" %>

<%

// ------------------------------------------------------------------------------------------------------
// 변수선언
// ------------------------------------------------------------------------------------------------------


String[] tag_array = {"TEXT", "HTML", "HTML+BR"};
String[] secret_array = {"공개글", "비밀글"};


Date date = new Date();
SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");
String today = simpleDate.format(date);


int i = 0;

int rs_class_seqid = 0;
String rs_class_name = "";

String sql = "";

// Request
String req_unify_str = "";

String rq_cid = "";
String rq_method = "";
String rq_target = "";
String rq_idx = "";

String rq_bref = "";
String rq_bstep = "";
String rq_blevel = "";

String rq_personal_info_agree = "";


rq_cid    = str_util.getArgsCheck(request.getParameter("cmsid"));
rq_method = str_util.getArgsCheck(request.getParameter("method"));
rq_target = str_util.getArgsCheck(request.getParameter("target"));
rq_idx    = str_util.getArgsCheck(request.getParameter("idx"));

rq_bref   = str_util.getArgsCheck(request.getParameter("b_ref"));
rq_bstep  = str_util.getArgsCheck(request.getParameter("b_step"));
rq_blevel = str_util.getArgsCheck(request.getParameter("b_level"));

rq_personal_info_agree = str_util.getArgsCheck(request.getParameter("personal_info_agree"));


if(rq_cid == null) { rq_cid = ""; }
if(rq_target == null || rq_target.equals("")) rq_target = "";

if(rq_idx == null) rq_idx = "";
if(rq_bref == null) rq_bref = "";
if(rq_bstep == null) rq_bstep = "";
if(rq_blevel == null) rq_blevel = "";

if(rq_personal_info_agree == null || rq_personal_info_agree.equals("")) rq_personal_info_agree = "";




if("".equals(rq_cid))
{  
  //out.println("<div id='wrap'>입력항목에 문제가 있습니다.</div>");
  
  String message_url = "/main/messagebox.action?cmsid=" + rq_cid + "&url=/&msg=" + URLEncoder.encode("잘못된 경로에 접근하셨습니다.", "UTF-8");
  
  out.println("<script type=\"text/javascript\">");
  out.println("//<![CDATA[");
  out.println("document.location.href = \"" + message_url + "\";");
  out.println("//]]>");
  out.println("</script>");
  
  if(stl!=null) {  stl.close();  stl = null; }
  
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
// 게시글 구분
// -----------------------------------------------------------------------------
ResultSet rs_class_list = null;

if(rs_inc_bclass.equals("1")) 
{
  sql = "select seqid, cname from board_class where cid = '" + rq_cid + "' order by cseq";
  rs_class_list = stl.executeQuery(sql);
}
// -----------------------------------------------------------------------------



// -----------------------------------------------------------------------------
// 로그인 정보
// -----------------------------------------------------------------------------
String bu_id = "";
String bu_name = "";
String bu_dept_cd = "";
String bu_dept_nm = "";
String bu_dept_oclass_nm = "";
String bu_dept_par_nm = "";

if(session.getAttribute("session_login_id") != null)
{

}
// -----------------------------------------------------------------------------
DBUtil dbset = null;
dbset = new DBUtil();

sql = "delete from board_file where cid = ? and freg = '0' and fsession = ? ";

dbset.setAutoCommit(false);
dbset.setQuery(sql);

i = 1;

dbset.setString(i++, rq_cid);
dbset.setString(i++, session.getId());

dbset.executeUpdate();
dbset.close_pstmt();

dbset.commit();
dbset.setAutoCommit(true);

// ------------------------------------------------------------------------------------------------------
// 쓰기 및 답변 권한이 있는지 체크
// ------------------------------------------------------------------------------------------------------
if(rs_inc_aw.equals("1") || rs_inc_ar.equals("1"))
{
    
    // ---------------------------------------------------------------------------
    // 답변일경우 데이터 읽기
    // ---------------------------------------------------------------------------
    
    int rs_seqid = 0;
    int rs_no = 0;
    int rs_bu_seqid = 0;
    int rs_bref = 0;
    int rs_blevel = 0;
    int rs_bstep = 0;
    int rs_bhit = 0;
    int rs_fimage_w = 0;
    int rs_fimage_h = 0;
    
    String rs_cid = "";
    String rs_bu_name = "";
    String rs_bu_dept_nm = "";
    String rs_bu_email = "";
    String rs_bu_pwd = "";
    String rs_bsubject = "";
    String rs_bcontent = "";
    String rs_btag = "";
    String rs_inst_id = "";
    String rs_inst_date = "";
    String rs_inst_ip = "";
  
    String rs_bdept = "";
    String rs_bdept_cd = "";
    String rs_bdept_name = "";
    
    if(!rq_idx.equals(""))
    {
      sql = "";
      sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, inst_id, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss'), inst_ip, bdept, bdept_name ";
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
       // rs_bu_dept_nm  = rs_list.getString(6);
        rs_bu_email    = rs_list.getString(6);
        rs_bu_pwd      = rs_list.getString(7);
        rs_bref        = rs_list.getInt(8);
        rs_blevel      = rs_list.getInt(9);
        rs_bstep       = rs_list.getInt(10);
        rs_bsubject    = rs_list.getString(11);
        
        rs_bcontent    = stl.getClobToString(rs_list, "bcontent");
        
        rs_btag        = rs_list.getString(13);
        rs_bhit        = rs_list.getInt(14);
        rs_inst_id     = rs_list.getString(15);
        rs_inst_date   = rs_list.getString(16);
        rs_inst_ip     = rs_list.getString(17);
        
        rs_bdept       = rs_list.getString(18);
        //rs_bdept_cd    = rs_list.getString(20);
        rs_bdept_name  = rs_list.getString(19);
        
        // 작성자
        if(rs_bu_name == null) { rs_bu_name = ""; }
        if(rs_bu_dept_nm == null) { rs_bu_dept_nm = ""; }
        
        if(rs_bu_dept_nm.equals("")) { rs_bu_dept_nm = rs_bu_name; }
        else { rs_bu_dept_nm = rs_bu_dept_nm + "(" + rs_bu_name + ")"; }
        
        // 문서종류에 따른 TAG 처리
        if(rs_btag.equals("0"))
        {
          if(rs_bcontent != null && rs_bcontent != "")
          {
            rs_bcontent = rs_bcontent.replaceAll("<", "&lt;");
            rs_bcontent = rs_bcontent.replaceAll(">", "&gt;");
            
            rs_bcontent = rs_bcontent.replaceAll("\n", "<br>");
            //rs_bcontent = rs_bcontent.replaceAll("\r", "<br>");
            
          }
        }
        else if(rs_btag.equals("2"))
        {
          if(rs_bcontent != null && rs_bcontent != "")
          {
            rs_bcontent = rs_bcontent.replaceAll("\n", "<br>");
            //rs_bcontent = rs_bcontent.replaceAll("\r", "<br>");
          }
        }
        
        
        rs_list.close();
      }
    }
    // ---------------------------------------------------------------------------
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
    
    <script language="javascript" src="js/jquery-ui.min.js"></script>
    
    <script type="text/javascript">
    //<![CDATA[
    
    function fun_send_form()
    {
      
      var form = document.board_form;
      
      <%
      if(session.getAttribute("session_login_id") == null)
      {
        %>
        if (form.bu_name.value.trim()=="")
        { 
          alert("\n작성자를 입력하세요.");
          form.bu_name.focus();
          return;
        }
        
        if (form.bu_pwd.value.trim()=="")
        { 
          alert("\n비밀번호를 입력하세요.");
          form.bu_pwd.focus();
          return;
        }
        <%
      }
      else
      {
        if(session.getAttribute("session_login_seq").equals("0"))
        {
          %>
          
          //if (form.bu_pwd.value.trim()=="")
          //{ 
          //  alert("\n비밀번호를 입력하세요.");
          //  form.bu_pwd.focus();
          //  return;
          //}
          
          <%
        }
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
      
      if (form.b_subject.value.trim()=="")
      { 
        alert("\n제목을 입력하세요.");
        form.b_subject.focus();
        return;
      }
      
      if (form.b_content.value.trim()=="")
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
      
      
      form.submit();
    }
    
    // E-Mail 확인
    function emailChk(email) 
    {
      var frm = document.regist
      var len = email.value.length
      var strmail = email.value
          
      // @ 으로 구분
      s1 = strmail.split("@")
      if(s1.length!=2){return false;}
          
      // @ 앞의 부분 체크
      mail_front = s1[0]
      if(mail_front.length<1) return false;
      for(var i=0;i<mail_front.length;i++)
      {
        str =mail_front.charAt(i)
        if((str<"a"||str>"z") && (str<"A"||str>"Z") && (str<"0"||str>"9") && (str!=="-") && (str!=="_")) return false;
      }
    
      // @뒤의 부분 체크
      mail_rear = s1[1]
      mail_rear_sp = mail_rear.split(".")
      if(mail_rear_sp.length<2) return false
      if(mail_rear.length<1) return false;
      for(var i=0;i<mail_rear.length;i++)
      {
        str = mail_rear.charAt(i)
        if((str<"a"||str>"z") && (str<"A"||str>"Z") && (str<"0"||str>"9") && (str!=="-") && (str!=="_") && (str!==".")) return false;
      }
    
      for(var i=1;i<mail_rear.length;i++)
      {
         if(mail_rear.charAt(i)=="." && mail_rear.charAt(i-1)==".") return false;
      }
    
      if(mail_rear.charAt(0)==".") return false;
      if(mail_rear.charAt(mail_rear.length-1)==".") return false;
    
      // domain name check
      var k = mail_rear_sp.length-1
      for(var i=0;i<mail_rear_sp[k].length;i++)
      {
         if((mail_rear_sp[k].charAt(i)<"a"||str>"z") && (mail_rear_sp[k].charAt(i)<"A"||str>"Z")) return false;
      }
    
      return true;
    }
    
    // 우편번호
    function fun_post()
    {
      var pop = window.open("/main/program_addon/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes");
    }
    
    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn)
    {
    		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
    		//document.board_form.roadFullAddr.value = roadFullAddr;
    		document.board_form.b_pjuso1.value = roadAddrPart1;
    		//document.board_form.b_pjuso2.value = roadAddrPart2;
    		document.board_form.b_pjuso2.value = addrDetail + " " + roadAddrPart2;
    		//document.board_form.engAddr.value = engAddr;
    		//document.board_form.jibunAddr.value = jibunAddr;
    		document.board_form.b_ppost.value = zipNo;
    		//document.board_form.admCd.value = admCd;
    		//document.board_form.rnMgtSn.value = rnMgtSn;
    		//document.board_form.bdMgtSn.value = bdMgtSn;
    }
    
    
    //]]>
    </script>
    
    
    
    <form name="board_form" method="post" action="board/board_insert.jsp">
    
    <input type="hidden" name="target"    value="<%=rq_target%>" />
    <input type="hidden" name="cmsid"     value="<%=rq_cid%>" />
    <input type="hidden" name="idx"       value="<%=rq_idx%>" />
    
    <input type="hidden" name="cc"        value="<%=rq_class_cd%>" />
    <input type="hidden" name="psize"     value="<%=rq_page_size%>" />
    <input type="hidden" name="page"      value="<%=rq_page%>" />
    <input type="hidden" name="st"        value="<%=rq_search_type%>" />
    <input type="hidden" name="sk"        value="<%=rq_search_key%>" />
    
    <input type="hidden" name="b_ref"     value="<%=rq_bref%>" />
    <input type="hidden" name="b_step"    value="<%=rq_bstep%>" />
    <input type="hidden" name="b_level"   value="<%=rq_blevel%>" />
    
    
    
    <%
    // -------------------------------------------------------------------------
    // 답글인 경우 질문 내용 보이기
    // -------------------------------------------------------------------------
    if(!rq_idx.equals(""))
    {
    %>
    
    <table class="basic_table">
    
    <caption class="HIDE">
	 		<strong>${menu_title} 질문 내용</strong>
		 	<p>${menu_title} 게시물의 항목(작성자, 작성일, 제목) 질문 내용을 나타내고 있습니다.</p>
		  </caption>
    
    <tr class="first_line">
      <th scope="row" width="20%" class="left">작성자</th>
      <td width="" ><%=rs_bu_dept_nm%></td>
    </tr>
    <tr>
      <th scope="row" width="20%" class="left">제목</th>
      <td><%=rs_bsubject%></td>
    </tr>
    
    </table>
    
    <div class="table_con" style="padding-bottom:30px;"><span class="t_con"><%=rs_bcontent%><span></div>
    
    <% 
    }
    %>
    
    
    
    <table class="basic_table">
    
    <caption class="HIDE" style="display: none">
  		<strong>${menu_title} 글쓰기</strong>
  		<p>${menu_title}의 게시물 항목(작성자, 비밀번호, 이메일, 전화번호, 주소등) 내용입력란을 나타내고 있습니다.</p>
  	</caption>
    
    <%
    // 비로그인 사용자
    if(session.getAttribute("session_login_id") == null)
    {
      %>
      
      <tr class="first_line">
        <th scope="row" class="first_cell" width="20%" class="left"><label for="bu_name">작성자</label></th>
        <td width=""><input type="text" name="bu_name" size="25" maxlength="15" value="" id="bu_name" /></td>     
      </tr>
      
  	  	<tr>
        <th scope="row" width=""><label for="bu_pwd">비밀번호</label></th>
        <td width=""><input type="password" name="bu_pwd" size="25" maxlength="15" value="" id="bu_pwd" /></td>
      </tr>
      
      <tr>
        <th scope="row" width="20%" class="left"><label for="bu_email">이메일</label></th>
        <td width=""><input type="text" name="bu_email" size="25" maxlength="50" value="" id="bu_email" /></td>
      </tr>
      
      <%
    }
    
    // 로그인 사용자
    else
    {
      %>
        
        <tr class="first_line">
          <th width="20%" scope="row" class="first_cell">작성자</th>
          <td width="80%"><%=session.getAttribute("session_login_name")%></td>
        </tr>
        
        <%
        
        if(session.getAttribute("session_login_seq").equals("0"))
        {
          %>
          
          <tr>
            <th scope="row" width="20%"><label for="bu_pwd">비밀번호</label></th>
            <td width="" colspan="3"><input type="password" name="bu_pwd" size="25" maxlength="15" value="" id="bu_pwd" /></td>
          </tr>
          
          <tr>
            <th scope="row" width="20%"><label for="bu_email">이메일</label></th>
            <td width="" colspan="3"><input type="text" name="bu_email" size="25" maxlength="50" value="" id="bu_email" /></td>
          </tr>
          
          <%
        }
    }
    
    
    
    // 구분
    if(rs_inc_bclass.equals("1") && rq_idx.equals(""))
    {
    %>
    
    <tr>
      <th scope="row" width="20%" class="left"><label for="b_class">구분</label></th>
      <td width="">
          <select name="b_class" class="select" id="b_class" size="1">
          <option value=''>구분선택</option>
          <%
          while(rs_class_list.next())
          {
            rs_class_seqid = rs_class_list.getInt(1);
            rs_class_name  = rs_class_list.getString(2);
            
            out.println("<option value='" + rs_class_seqid + "'>" + rs_class_name + "</option>");
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
      <td width=""><input type="text" class="input" id="b_subject" name="b_subject" style="width:100%;" maxlength="255" value="" /></td>
    </tr>
    
    <%
    
    if(rs_inc_bsecret_view.equals("1") && rq_idx.equals(""))
    {
    %>
    <tr>
      <th scope="row" width="20%" class="left">비밀글</th>
      <td width="">
          <select name="b_secret" size="1" id="b_secret" class="select">
          <%
          for(i = 0; i < secret_array.length; i++)
          {
            out.println("<option value='" + i + "'>" + secret_array[i] + "</option>");
          }
          %>
          </select>
      </td>
    </tr>
    <%
    }
    %>
    
    <tr class="table_height">
      <th scope="row" style="width:20%;" class="left"><label for="b_content">내용</label></th>
      <td><textarea name="b_content" rows="20" style="width:100%;" id="b_content" title="내용을 입력하세요"></textarea></td>
    </tr>
    <%
    if(rs_inc_bfile.equals("1") && rq_idx.equals(""))
    {
    %>
    <tr>
      <th scope="row" width="20%" class="left">첨부파일</th>
      <td width=""><iframe id="insertFileWin" width="480" height="120" src="/upload/upload_form.jsp?mod=new&amp;cid=<%=rq_cid%>&amp;sid=<%=session.getId()%>" scrolling="no" frameborder="0" title="첨부파일 목록"></iframe></td>
    </tr>
    <%
    }
    %>
    </table>
    
    <div class="flex_r_ec search_double_bt">
      <a class="btn_square_blue" href="#fun_send_form" onclick="fun_send_form(); return false;">등록</a>
      <a class="btn_square_line" href="board.do?<%=req_unify_str%>&amp;method=l&amp;idx=&amp;page=<%=rq_page%>">취소</a>
    </div>
    
    </form>
    
    
    
    <%
}

// ------------------------------------------------------------------------------------------------------
// 쓰기 및 답변 권한이 없을때 처리
// ------------------------------------------------------------------------------------------------------
else
{
  if(dbset != null) { dbset.close(); dbset = null; }
  if(stl!=null) { stl.close(); stl = null; }

  out.println("<form name='board_form' method='post' action='board.action'>");
  
  out.println("<input type='hidden' name='method'    value='' />");
  out.println("<input type='hidden' name='target'    value='" + rq_target + "' />");
  out.println("<input type='hidden' name='cmsid'     value='" + rq_cid + "' />");
  out.println("<input type='hidden' name='mode'      value='' />");
  
  out.println("<input type='hidden' name='cc'        value='" + rq_class_cd + "'>");
  out.println("<input type='hidden' name='psize'     value='" + rq_page_size + "'>");
  out.println("<input type='hidden' name='page'      value='" + rq_page + "' />");
  out.println("<input type='hidden' name='st'        value='" + rq_search_type + "' />");
  out.println("<input type='hidden' name='sk'        value='" + rq_search_key + "' />");
  
  out.println("</form>");
  
  out.println("<script language='JavaScript'>");
  out.println("<!--");
  out.println("  var form = document.board_form;");
  out.println("  alert('게시판 글작성 권한이 없거나, 별도의 인증(로그인)이 필요한 게시판 입니다.');");
  out.println("  form.method.value = 'l';");
  out.println("  form.submit();");
  out.println("-->");
  out.println("</script>");
}

if(dbset != null) { dbset.close(); dbset = null; }
if(stl!=null) { stl.close(); stl = null; }

%>