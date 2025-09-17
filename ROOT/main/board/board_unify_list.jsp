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

String rs_cid = "";
String rs_bu_name = "";
String rs_bu_email = "";
String rs_bu_pwd = "";
String rs_bsubject = "";
String rs_bcontent = "";
String rs_btag = "";
String rs_bsecret = "";

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

request_str = "cmsid=" + rq_cid + "&target=" + rq_target + "&nickname=" + rq_nickname + "&st=" + rq_search_type + "&sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

req_unify_str = "";
req_unify_str = req_unify_str + "cmsid=" + rq_cid + "&target=" + rq_target + "&nickname=" + rq_nickname;
req_unify_str = req_unify_str + "&st=" + rq_search_type + "&sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

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
    request_where_str = request_where_str + " and DBMS_LOB.INSTR(bcontent, '" + rq_search_key + "') > 0 ";
  }
  else if(rq_search_type.equals("2"))
  {
    request_where_str = request_where_str + " and bu_name like '%" + rq_search_key + "%' ";
  }
}
// ------------------------------------------------------------------------------------------------------


// ------------------------------------------------------------------------------------------------------
// 실과소 통합 게시판
// ------------------------------------------------------------------------------------------------------
String cid_str = "";
String cid_sql = "";
String bod_str = "";
String water_str = "";
String health_str = "";

cid_str = "";


// 공지사항
if(rq_cid.equals("101040102000")){
  bod_str = "0301";
  water_str = ", 107050100000";
  health_str = ", 106040100000";

// 고시공고
} else if(rq_cid.equals("101050500000")) {
  bod_str = "0302";
  water_str = ", 107050200000";
  health_str = ", 106041000000";

// 공시송달
} else if(rq_cid.equals("101050900000")) {
  bod_str = "0303";
  water_str = ", 107050300000";
  health_str = ", 106041100000";

// 입법예고
} else if(rq_cid.equals("101050600000")) {
  bod_str = "0304";
  water_str = ", 107050800000";

// 정기공표
} else if(rq_cid.equals("101030102030")) { 
  bod_str = "0305";
  water_str = "";

// 수시공표
} else if(rq_cid.equals("101030102040")) { 
  bod_str = "0306";
  water_str = "";

// 행정서식
} else if(rq_cid.equals("101030201000")) { 
  bod_str = "0202";
  water_str = ", 107020500000";

} else bod_str = "0301";


// 실과소 반복
for(i = 1; i <= 27; i++)
{
  // 콤마
  if(cid_str != "") cid_str = cid_str + ", ";
  
  // 부서 자릿수 (1, 2)
  if(i < 10) cid_str =  cid_str + "20" + i;
  else cid_str =  cid_str + "2" + i;
  
  cid_str = cid_str + bod_str + "00000";
}

// 수도사업소
cid_str = cid_str + water_str;
//보건소
cid_str = cid_str + health_str;


cid_str = "101040102000";

// 실과소 통합 게시판 - SQL문 조합
cid_sql =  " cid in (" + cid_str + ") ";

// ------------------------------------------------------------------------------------------------------


// ------------------------------------------------------------------------------------------------------
// 페이징
// ------------------------------------------------------------------------------------------------------

String reqPage = "";
int pageSize = 10;
int curPage = 0;
int totPage = 0;
int lastNum = 0;

int intNumOfPage = 10;
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
sql = "select count(*) from board ";
sql = sql + "where " + cid_sql;
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

sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, bsecret, inst_date, rk from ( ";
sql = sql + "select rownum as rnum, b.* from ( ";

sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, bsecret, inst_date, rank() over(order by bref asc, bstep desc) as rk ";
sql = sql + "from board ";

sql = sql + "where " + cid_sql;

sql = sql + request_where_str;

sql = sql + " order by bref desc, bstep asc ";

sql = sql + ") b ";
sql = sql + ") a ";
sql = sql + "where a.rnum > " + lastNum + " ";
sql = sql + "and a.rnum <= " + (lastNum + pageSize);

//out.println(sql);
ResultSet rs_list = stl.executeQuery(sql);
// ------------------------------------------------------------------------------------------------------


%>

<script language="JavaScript">
<!--


function fun_view(idx)
{
  var form = document.board_form;
  
  form.method.value = "v";
  form.idx.value = idx;
  
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
  
  form.method.value = "l";
  form.page.value = "1";
  form.idx.value = "";
  
  form.submit();
}


//-->
</script>


<div id="content">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr>
  <td width="100%" align="center" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        
        <tr>
          <td width="100%">
              <table width="100%" border="0" cellspacing="1" cellpadding="2">
                
                <form name="board_form" method="post" action="program.action" onsubmit="return fun_search();">
                
                <input type="hidden" name="method"    value="<%=rq_method%>">
                <input type="hidden" name="target"    value="<%=rq_target%>">
                <input type="hidden" name="cmsid"     value="<%=rq_cid%>">
                <input type="hidden" name="nickname"  value="<%=rq_nickname%>">
                <input type="hidden" name="idx"       value="">
                
                <input type="hidden" name="page"      value="<%=rq_page%>">
                
                
                <tr>
                  <td width="50%" height="20" align="left">
                      <strong>Total</strong> <%=record_count%> |
                      <strong>Page</strong> <%=curPage%>/<%=totPage%>
                  </td>
                   <td><label for="st" class="HIDE">제목찾기</label></td>                  <td><label for="sk" class="HIDE">검색어</label></td>                  <td><label for="st1" class="HIDE">검색</label></td>
                   <td width="50%" height="20" align="right">
                      <select name="st" size="1" id="st">
                        <%
                        for(i = 0; i < b_search_type_array.length; i++)
                        {
                          if(rq_search_type.equals(""+i))
                          {
                            out.println("<option value='" + i + "' selected>" + b_search_type_array[i] + "</option>");
                          }
                          else
                          {
                            out.println("<option value='" + i + "'>" + b_search_type_array[i] + "</option>");
                          }
                        }
                        %>
                        
                      </select>
                      <label for="sk"><input type="text" name="sk" size="15" id="sk" maxlength="15" value="<%=rq_search_key%>"></label>
                      <input type="image" src="board/images/button_search.gif" width="50" height="20" border="0" align="absmiddle" alt="검색">
                  </td>
                </tr>
                
                </form>
              
              </table>
          </td>
        </tr>
        
        <tr><td width="100%" height="5"></td></tr>
        
        <tr>
          <td width="100%">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="9%" height="3" bgcolor="#e0144c"></td>
                  <td width="91%" height="3" colspan="10" bgcolor="#005bb0"></td>
                </tr>
              </table>
              <table width="100%" border="0" cellspacing="0" cellpadding="0" summary="${menu_title} 목록">
              <caption class="HIDE">${menu_title} 목록</caption>
              <thead>
                
                <tr>
                  <th width="9%"  height="28" style="text-align:center" scope="col"><font color="#003f85"><strong>번호</strong></font></th>
                  <td height="28" align="center"><img src="board/images/line.gif" width="1" height="28" alt="line" /></td>
                  <th width="47%" height="28" style="text-align:center" scope="col"><font color="#003f85"><strong>제목</strong></font></th>
                  <td height="28" align="center"><img src="board/images/line.gif" width="1" height="28" alt="line" /></td>
                  <th width="8%"  height="28" style="text-align:center" scope="col"><font color="#003f85"><strong>첨부</strong></font></th>
                  <td height="28" align="center"><img src="board/images/line.gif" width="1" height="28" alt="line" /></td>
                  <th width="15%" height="28" style="text-align:center" scope="col"><font color="#003f85"><strong>작성자</strong></font></th>
                  <td height="28" align="center"><img src="board/images/line.gif" width="1" height="28" alt="line" /></td>
                  <th width="12%" height="28" style="text-align:center" scope="col"><font color="#003f85"><strong>작성일</strong></font></th>
                  <td height="28" align="center"><img src="board/images/line.gif" width="1" height="28" alt="line" /></td>
                  <th width="9%"  height="28" style="text-align:center" scope="col"><font color="#003f85"><strong>조회수</strong></font></th>
                </tr>
                </thead>
                <tbody>
                
                <tr><td width="100%" height="1" colspan="11" bgcolor="#BBBBBB"></td></tr>
                
                <tr><td width="100%" height="5" colspan="11"></td></tr>
                
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
                    
                    // 부서명칭
                    dept_str = stl.getDept(rs_cid, 0, 2);
                    
                    // 작성자
                    writer_str = stl.getDept(rs_cid, 0, 0);
                    
                    // 제목
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
                      if(rs_files_cnt > 0) files_img = "<img src='board/images/file_icon_off.gif' alt='첨부파일' width='12' height='12' border='0'>";
                    }
                    rs_files.close();
                    // ---------------------------------------------------------
                    
                    //rs_bsubject = "<a href='javascript:fun_view(" + rs_seqid + ");' alt='" + rs_bsubject + "'>[" + dept_str + "] " + rs_bsubject + "</a>";
                    //rs_bsubject = "<a href='javascript:fun_view(" + rs_seqid + ");' alt='" + rs_bsubject + "'>" + rs_bsubject + "</a>";
					               
					               rs_bsubject = "<a href='program.action?" + req_unify_str + "&method=v&idx=" + rs_seqid + "&page=" + rq_page + "' alt='" + rs_bsubject + "'>" + rs_bsubject + "</a>";
  				              
					               
                    
                    out.println("<tr>");
                    out.println("  <td height='30' align='center'>" + rs_rank + "</td>");
                    out.println("  <td height='25' align='center'></td>");
                    out.println("  <td height='30' align='left'>" + rs_bsubject + "</td>");
                    out.println("  <td height='30' align='center'></td>");
                    out.println("  <td height='30' align='center'>" + files_img + "</td>");
                    out.println("  <td height='30' align='center'></td>");
                    out.println("  <td height='30' align='center'>" + writer_str + "</td>");
                    out.println("  <td height='30' align='center'></td>");
                    out.println("  <td height='30' align='center'>" + rs_inst_date + "</td>");
                    out.println("  <td height='30' align='center'></td>");
                    out.println("  <td height='30' align='center'>" + rs_bhit + "</td>");
                    out.println("</tr>");
                    
                    i++;
                    
                    out.println("<tr><td width='100%' height='1' colspan='11' background='board/images/dot_line_p.gif' alt=''></td></tr>");

                    
                  }
                  
                  rs_list.close();
                  rs_list = null;
                }
                else
                {
                  out.println("<tr><td width='100%' height='200' colspan='11' align='center'>등록된 내용이 없습니다.</td></tr>");
                }                %>
                
                <tr><td width="100%" height="5" colspan="11"></td></tr>
                <tr><td width="100%" height="2" colspan="11" bgcolor="#005bb0"></td></tr>

                </tbody>
              </table>
          </td>
        </tr>
        
        
        
        <tr><td width="100%" height="10"></td></tr>

        <tr>
          <td width="100%">
              <table width="100%" border="0" cellspacing="1" cellpadding="2">
              
                <tr>
                  <td width="20%"></td>
                  
                  <td width="60%" height="30" align="center">
                      
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
                        //out.println("<a href='javascript:fun_jump(1);'><img src='board/images/a_ic_ppre.gif' border='0' width='20' height='13' align='absmiddle' alt='처움페이지'></a>");
                        out.println("<a href='program.action?" + req_unify_str + "&method=l&idx=&page=1'><img src='board/images/a_ic_ppre.gif' border='0' width='20' height='13' align='absmiddle' alt='처음페이지'></a>");
                        
                        // 이전10개페이지보여주기
                        //out.println("<a href='javascript:fun_jump(" + (intStart - intNumOfPage) + ");'><img src='board/images/a_ic_pre.gif' border='0' width='20' height='13' align='absmiddle' alt='이전페이지'></a>");
                        out.println("<a href='program.action?" + req_unify_str + "&method=l&idx=&page=" + (intStart - intNumOfPage) + "'><img src='board/images/a_ic_pre.gif' border='0' width='20' height='13' align='absmiddle' alt='이전페이지' /></a>");
                      }
                      else
                      {
                        out.println("<img src='board/images/a_ic_ppre.gif' border='0' width='20' height='13' align='absmiddle' alt='처음페이지'>");
                        out.println("<img src='board/images/a_ic_pre.gif' border='0' width='20' height='13' align='absmiddle' alt='이전페이지'>");
                      }
                      
                      for(i = intStart; i <= intEnd; i++)
                      {
                        if(i == curPage)
                        {
                          out.println("<strong>[" + i + "]</strong>");
                        }
                        else
                        {
                          //out.println("<a href='javascript:fun_jump(" + i + ");'>[" + i + "]</a>");
						                    out.println("<a href='program.action?" + req_unify_str + "&method=l&idx=&page=" + i + "'>[" + i + "]</a>");
                        }
                      }
                      
                      if(totPage > intEnd)
                      {
                        // 다음10개페이지로
                        //out.println("<a href='javascript:fun_jump(" + (intEnd + 1) + ");'><img src='board/images/a_ic_next.gif' border='0' width='20' height='13' align='absmiddle' alt='다음페이지'></a>");
                        out.println("<a href='program.action?" + req_unify_str + "&method=l&idx=&page=" + (intEnd + 1) + "'><img src='board/images/a_ic_next.gif' border='0' width='20' height='13' align='absmiddle' alt='다음페이지'></a>");
        
                        // 마지막페이지로
                        //out.println("<a href='javascript:fun_jump(" + totPage + ");'><img src='board/images/a_ic_nnext.gif' border='0' width='20' height='13' align='absmiddle' alt='마지막페이지'></a>");
                        out.println("<a href='program.action?" + req_unify_str + "&method=l&idx=&page=" + totPage + "'><img src='board/images/a_ic_nnext.gif' border='0' width='20' height='13' align='absmiddle' alt='마지막페이지'></a>");
                      }
                      else
                      {
                        out.println("<img src='board/images/a_ic_next.gif' border='0' width='20' height='13' align='absmiddle' alt='다음페이지'>");
                        out.println("<img src='board/images/a_ic_nnext.gif' border='0' width='20' height='13' align='absmiddle' alt='마지막페이지'>");
                      }
                      %>
                  </td>
                  
                  <td width="20%" align="right"></td>
                </tr>
                
              </table>
          </td>
        </tr>
        
      </table>
  </td>
</tr>

</table>

</div>




<%

if(stl!=null) { 
 stl.close(); 
 stl = null;
}

%>