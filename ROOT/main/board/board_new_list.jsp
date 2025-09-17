<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>


<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%@ page import="java.text.SimpleDateFormat, java.util.Calendar, java.util.Date" %>
<%@ page import="java.text.*" %>

<jsp:useBean id="stl" class="goodit.common.dao.DBUtil" scope="page"/>


<%


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

String rq_cid = "";
String rq_method = "";
String rq_target = "";
String rq_nickname = "";
String rq_idx = "";

rq_cid      = request.getParameter("cmsid");
rq_method   = request.getParameter("method");
rq_target   = request.getParameter("target");
rq_nickname = request.getParameter("nickname");
rq_idx      = request.getParameter("idx");

if(rq_target == null || rq_target.equals("")) rq_target = "";
if(rq_method == null || rq_method.equals("")) rq_method = "";

if(rq_cid==null) { rq_cid = ""; }

if("".equals(rq_cid)) {  
  if(stl!=null) {  stl.close();  stl = null; }
  out.println("<div id='content'>입력항목에 문제가 있습니다.</div>");
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
int rs_unify_cnt = 0;

String rs_cid = "";
String rs_bu_name = "";
String rs_bu_email = "";
String rs_bu_pwd = "";
String rs_bsubject = "";
String rs_bcontent = "";
String rs_btag = "";
String rs_bsecret = "";
String rs_unify_cid = "";
String rs_title_nm = "";

Date rs_inst_date;




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
if(rq_search_key == null || rq_search_key == "") { rq_search_key = ""; }

request_str = "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;nickname=" + rq_nickname + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

req_unify_str = "";
req_unify_str = req_unify_str + "cmsid=" + rq_cid + "&amp;target=" + rq_target + "&amp;nickname=" + rq_nickname;
req_unify_str = req_unify_str + "&amp;st=" + rq_search_type + "&amp;sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

// ------------------------------------------------------------------------------------------------------



// ------------------------------------------------------------------------------------------------------
// 조건식에 의한 SQL문 만들기
// ------------------------------------------------------------------------------------------------------
if(rq_search_type != "" && rq_search_key != "")
{
  if(rq_search_type.equals("0"))
  {
    request_where_str = request_where_str + " and a.bsubject like '%" + rq_search_key + "%' ";
  }
  else if(rq_search_type.equals("1"))
  {
    request_where_str = request_where_str + " and DBMS_LOB.INSTR(a.bcontent, '" + rq_search_key + "') > 0 ";
  }
  else if(rq_search_type.equals("2"))
  {
    request_where_str = request_where_str + " and a.bu_name like '%" + rq_search_key + "%' ";
  }
}
// ------------------------------------------------------------------------------------------------------



// ------------------------------------------------------------------------------------------------------
// 페이징
// ------------------------------------------------------------------------------------------------------

String reqPage = "";
int pageSize = 10;
int curPage = 0;
int totPage = 0;
int lastNum = 0;

int intNumOfPage = 5;
int intStart = 0;
int intEnd = 0;

int record_count = 0;


reqPage = request.getParameter("page");

if(reqPage == null || reqPage.equals(""))
{
  curPage = 1;
}
else
{
  curPage = Integer.parseInt(reqPage);
}

sql = "";
sql = sql + "select count(*) from board a ";

sql = sql + "where a.blevel = 0  ";

sql = sql + "and a.cid in ('101060200000', '103040201000', '101060600000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040102000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040103000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040104000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040107000')) ";

// 휴지통
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


// ------------------------------------------------------------------------------------------------------
// 목록구성
// ------------------------------------------------------------------------------------------------------

sql = "";

sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, bsecret, inst_date, rk, unify_cnt, unify_cid, title_nm from ( ";
sql = sql + "select rownum as rnum, b.* from ( ";

sql = sql + "select a.seqid, a.cid, a.bno, a.bu_seqid, a.bu_name, a.bu_email, a.bu_pwd, a.bref, a.blevel, a.bstep, a.bsubject, a.bcontent, a.btag, a.bhit, a.bsecret, a.inst_date, rank() over(order by a.bref asc, a.bstep desc) as rk, ";
sql = sql + "(select count(*) from board_unify where ucid = a.cid) unify_cnt, ";
sql = sql + "(select cid from board_unify where ucid = a.cid) unify_cid, ";
sql = sql + "(select cname from site_content where cid = a.cid) title_nm ";
sql = sql + "from board a ";

sql = sql + "where a.blevel = 0  ";

sql = sql + "and a.cid in ('101060200000', '103040201000', '101060600000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040102000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040103000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040104000') ";
//sql = sql + "or a.cid in (select ucid from board_unify where cid = '101040107000')) ";

// 휴지통
sql = sql + "and brecycle = '0' ";

sql = sql + request_where_str + " ";

sql = sql + "order by a.inst_date desc ";

sql = sql + ") b ";
sql = sql + ") a ";
sql = sql + "where a.rnum > " + lastNum + " ";
sql = sql + "and a.rnum <= " + (lastNum + pageSize);

//out.println(sql);
ResultSet rs_list = stl.executeQuery(sql);
// ------------------------------------------------------------------------------------------------------

%>


<script type="text/javascript">

function fun_view(idx)
{
  var form = document.board_form;
  
  form.method.value = "view";
  form.idx.value = idx;
  
  form.submit();
}

function fun_jump(page)
{
  var form = document.board_form;
  
  form.method.value = "list";
  form.idx.value = "";
  form.page.value = page;
  form.submit();
}

function fun_search()
{
  var form = document.board_form;
  
  form.method.value = "list";
  form.page.value = "1";
  form.idx.value = "";
  
  form.submit();
}

</script>


<div class="wrap">
  
  <div class="data_tables">
    
    <div class="info_bar">
    
      <div class="count">
        <span class="bold">Total</span><span> <%=record_count%> | </span>
        <span class="bold">Page</span><span> <%=curPage%>/<%=totPage%></span>
      </div>
      
      <div class="search_bar">
        
        <form name="board_form" method="post" action="program.action" onsubmit="return fun_search();">
        <fieldset>
				    <legend class="HIDE">검색</legend>
        <input type="hidden" name="method"    value="<%=rq_method%>" />
        <input type="hidden" name="target"    value="<%=rq_target%>" />
        <input type="hidden" name="cmsid"     value="<%=rq_cid%>" />
        <input type="hidden" name="nickname"  value="<%=rq_nickname%>" />
        <input type="hidden" name="idx"       value="" />
        
        <input type="hidden" name="page"      value="<%=rq_page%>" />
        
        <select name="st" size="1" id="st">  
          
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
        
        <label for="sk"><input type="text" name="sk" id="sk" size="15" maxlength="15" value="<%=rq_search_key%>" /></label>
        <div class="button deep_wt"><input type="submit" value="검 색" /></div>
        </fieldset>
        </form>
        
      </div>
      
    </div>
    
    <table summary="${menu_title} 목록">
      
      <caption class="HIDE">${menu_title} 목록</caption>
      
      <thead>
      
      <tr class="first_line">
        <th scope="col" class="first_cell" style="width:8%;">번호</th>
        <th scope="col" style="width:48%;">제목</th>
        <th scope="col" style="width:7%;">첨부</th>
        <th scope="col" style="width:15%;">작성자</th>
        <th scope="col" style="width:12%;">작성일</th>
        <th scope="col" style="width:10%;">조회수</th>
      </tr>
      
      </thead>
      
      <tbody>
      
      <%
      
      i = 0;
      
      String dept_str = "";
      String writer_str = "";
      
      if(record_count > 0)
      {
        
        while(rs_list.next())
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
          //rs_bcontent    = rs_list.getString(12);
          rs_btag        = rs_list.getString(13);
          rs_bhit        = rs_list.getInt(14);
          rs_bsecret     = rs_list.getString(15);
          rs_inst_date   = rs_list.getDate(16);
          
          rs_rank        = rs_list.getInt(17);
          
          rs_unify_cnt   = rs_list.getInt(18);
          rs_unify_cid   = rs_list.getString(19);
          rs_title_nm    = rs_list.getString(20);
          
          // 부서명칭
          dept_str = stl.getDept(rs_cid, 0, 2);
          
          // 작성자
          writer_str = stl.getDept(rs_cid, 0, 0);
          
          // 제목
          rs_bsubject = "[" + rs_title_nm + "] " + rs_bsubject;
          if(rs_bsubject.length() > 24) rs_bsubject = rs_bsubject.substring(0, 24) + "...";
          
          // ---------------------------------------------------------
          // 첨부파일
          // ---------------------------------------------------------
          files_img = "";
          sql = "select count(*) from board_file where cid = '" + rs_cid + "' and bseqid = " + rs_seqid;
          ResultSet rs_files = stl.executeQuery(sql);
          if(rs_files.next())
          {
            rs_files_cnt = rs_files.getInt(1);
            if(rs_files_cnt > 0) files_img = "<img src='board/images/file_icon_off.gif' alt='첨부파일' width='12' height='12' border='0' />";
          }
          rs_files.close();
          // ---------------------------------------------------------
          
          //rs_bsubject = "<a href='#fun_view' onclick='fun_view(" + rs_seqid + ");' alt='" + rs_bsubject + "'>[" + dept_str + "] " + rs_bsubject + "</a>";
          //rs_bsubject = "<a href='#fun_view' onclick='fun_view(" + rs_seqid + ");' alt='" + rs_bsubject + "'>" + rs_bsubject + "</a>";
          
          
          
          //rs_bsubject = "<a href='program.action?" + req_unify_str + "&amp;method=view&amp;idx=" + rs_seqid + "&amp;page=" + rq_page + "' alt='" + rs_bsubject + "'>" + rs_bsubject + "</a>";
          
          if(rs_unify_cnt == 0)
          {
            rs_bsubject = "<a href='board.action?cmsid=" + rs_cid + "&amp;idx=" + rs_seqid + "&amp;method=v' title='" + rs_bsubject + "'>" + rs_bsubject + "</a>";
          }
          else
          {
            rs_bsubject = "<a href='board_unify.action?cmsid=" + rs_unify_cid + "&amp;idx=" + rs_seqid + "&amp;method=v' title='" + rs_bsubject + "'>" + rs_bsubject + "</a>";
          }
          
          
          out.println("<tr>");
          out.println("  <td align='center'>" + rs_rank + "</td>");
          out.println("  <td align='left'>" + rs_bsubject + "</td>");
          out.println("  <td align='center'>" + files_img + "</td>");
          out.println("  <td align='center'>" + rs_bu_name + "</td>");
          out.println("  <td align='center'>" + rs_inst_date + "</td>");
          out.println("  <td align='center'>" + rs_bhit + "</td>");
          out.println("</tr>");
          
          i++;
          
        }
        
        rs_list.close();
        rs_list = null;
      }
      else
      {
        out.println("<tr><td colspan='6'>등록된 내용이 없습니다.</td></tr>");
      }                %>
      
      </tbody>
      
    </table>
    
    
    <div id="pagingNav">
      
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
        out.println("<a class='first' href='program.action?" + req_unify_str + "&amp;method=list&amp;idx=&amp;page=1'>처음</a>");
        
        // 이전10개페이지보여주기
        out.println("<a class='previ' href='program.action?" + req_unify_str + "&amp;method=list&amp;idx=&amp;page=" + (intStart - intNumOfPage) + "'>이전</a>");
      }
      else
      {
        out.println("<a class='first' href='#first'>처음</a>");
        out.println("<a class='previ' href='#previ'>이전</a>");
      }
      
      for(i = intStart; i <= intEnd; i++)
      {
        if(i == curPage)
        {
           out.println("<a class='cur_num' href='#" + i + "'>" + i + "</a>");
        }
        else
        {
           out.println("<a class='num' href='program.action?" + req_unify_str + "&amp;method=list&amp;idx=&amp;page=" + i + "'>" + i + "</a>");
        }
      }
      
      if(totPage > intEnd)
      {
        // 다음10개페이지로
        out.println("<a class='next' href='program.action?" + req_unify_str + "&amp;method=list&amp;idx=&amp;page=" + (intEnd + 1) + "'>다음</a>");
  
        // 마지막페이지로
        out.println("<a class='last' href='program.action?" + req_unify_str + "&amp;method=list&amp;idx=&amp;page=" + totPage + "'>마지막</a>");
      }
      else
      {
        out.println("<a class='next' href='#next'>다음</a>");
        out.println("<a class='last' href='#last'>마지막</a>");
      }
      %>
      
    </div>
    
  </div>
  
</div>

<%

if(stl!=null) { 
 stl.close(); 
 stl = null;
}

%>