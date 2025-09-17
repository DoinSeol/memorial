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

int i = 0;

String sql = "";
String url_path = "";

int record_file_count = 0;

String writer_str = "";


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
String rs_bu_email = "";
String rs_bu_pwd = "";
String rs_bsubject = "";
String rs_bcontent = "";
String rs_btag = "";
String rs_inst_date = "";

String rs_a_cid = "";
String rs_a_bu_name = "";
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
String rq_nickname = "";
String rq_idx = "";

String rq_bref = "";
String rq_bstep = "";
String rq_blevel = "";

String rq_passwd = "";


rq_cid      = request.getParameter("cmsid");
rq_method   = request.getParameter("method");
rq_target   = request.getParameter("target");
rq_nickname = request.getParameter("nickname");
rq_idx      = request.getParameter("idx");

rq_bref   = request.getParameter("b_ref");
rq_bstep  = request.getParameter("b_step");
rq_blevel = request.getParameter("b_level");

rq_passwd = request.getParameter("passwd");

if(rq_cid == null) rq_cid = "";

if(rq_idx == null) rq_idx = "";
if(rq_bref == null) rq_bref = "";
if(rq_bstep == null) rq_bstep = "";
if(rq_blevel == null) rq_blevel = "";

if(rq_target == null || rq_target.equals("")) rq_target = "";
if(rq_passwd == null || rq_passwd.equals("")) rq_passwd = "";

if("".equals(rq_cid) || "".equals(rq_idx)) {  
  if(stl!=null) {  stl.close();  stl = null; }
  out.println("<div id='content'>입력항목에 문제가 있습니다.</div>");
  return;
}


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

request_str = "cmsid=" + rq_cid + "&target=" + rq_target + "&st=" + rq_search_type + "&sk=" + URLEncoder.encode(rq_search_key, "UTF-8");

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


String cid_str = "";
String cid_sql = "";
String bod_str = "";
String water_str = "";
String health_str = "";

cid_str = "";


// 공지사항
if(rq_cid.equals("101050100000")){
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
  water_str = ", 107050400000";

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
// 보건소
cid_str = cid_str + health_str;

cid_str = "101040102000";

// 실과소 통합 게시판 - SQL문 조합
cid_sql =  " cid in (" + cid_str + ") ";

// ------------------------------------------------------------------------------------------------------



sql = "";
sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') ";
sql = sql + "from board ";
//sql = sql + "where cid = '" + rq_cid + "' and seqid = " + rq_idx;
sql = sql + "where " + cid_sql + " and seqid = " + rq_idx;

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
  
  // 작성자
  writer_str = stl.getDept(rs_cid, 0, 0);
  
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
  
  // 읽은수 증가
  sql = "update board set bhit = bhit + 1 ";
  //sql = sql + "where cid = '" + rq_cid + "' and seqid = " + rq_idx;
  sql = sql + "where seqid = " + rq_idx;
  stl.executeUpdate(sql);
}

rs_list.close();


// ------------------------------------------------------------------------------------------------------
// 이전글
// ------------------------------------------------------------------------------------------------------
sql = "";
sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') from ( ";
sql = sql + "select rownum as rnum, b.* from ( ";

sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, inst_date ";
sql = sql + "from board ";
//sql = sql + "where cid = '" + rq_cid + "' and blevel = 0 and seqid > " + rq_idx + " and bref != " + rs_bref + " order by seqid asc ";
sql = sql + "where " + cid_sql + " and blevel = 0 and seqid > " + rq_idx + " and bref != " + rs_bref + " ";

sql = sql + request_where_str;

sql = sql + " order by seqid asc ";
          

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
sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, to_char(inst_date, 'yyyy-mm-dd hh24:mi:ss') from ( ";
sql = sql + "select rownum as rnum, b.* from ( ";

sql = sql + "select seqid, cid, bno, bu_seqid, bu_name, bu_email, bu_pwd, bref, blevel, bstep, bsubject, bcontent, btag, bhit, inst_date ";
sql = sql + "from board ";
//sql = sql + "where cid = '" + rq_cid + "' and blevel = 0 and seqid < " + rq_idx + " and bref != " + rs_bref + " order by seqid desc ";
sql = sql + "where " + cid_sql + " and blevel = 0 and seqid < " + rq_idx + " and bref != " + rs_bref + " ";

sql = sql + request_where_str;

sql = sql + " order by seqid desc ";

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
sql = sql + "where cid = '" + rs_cid + "' and bseqid = " + rq_idx + " and freg = '1'";
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
sql = sql + "where cid = '" + rs_cid + "' and bseqid = " + rq_idx + " and freg = '1' ";
sql = sql + "order by seqid asc ";
ResultSet rs_files = stl.executeQuery(sql);


// 첨부 파일이 사진이면 첫번째 사진을 다음 특수 문자료 변환
// [image] [image_c] [image_r] [image_l]
if(record_file_count > 0)
{
  sql = "";
  sql = sql + "select fname_s, fimage_w, fimage_h ";
  sql = sql + "from board_file ";
  sql = sql + "where cid = '" + rs_cid + "' and bseqid = " + rq_idx + " and freg = '1' ";
  sql = sql + "order by seqid asc ";
  ResultSet rs_files_img = stl.executeQuery(sql);
  
  if(rs_files_img.next())
  {
    // 파일 저장 URL
    url_path = stl.getPath(rs_cid, 0, "rel");
    
    rs_fname_s  = rs_files_img.getString(1);
    rs_fimage_w = rs_files_img.getInt(2);
    rs_fimage_h = rs_files_img.getInt(3);
    
    if(rs_fimage_w > 650) rs_fimage_w = 650;
    
    rs_bcontent = rs_bcontent.replaceAll("@image_c@", "<center><img src='" + url_path + "/upload/board/" + rs_fname_s + "' border='0' width='" + rs_fimage_w + "'></center>");
    rs_bcontent = rs_bcontent.replaceAll("@image_l@", "<img src='" + url_path + "/upload/board/" + rs_fname_s + "' border='0' width='" + rs_fimage_w + "' align='left'>");
    rs_bcontent = rs_bcontent.replaceAll("@image_r@", "<img src='" + url_path + "/upload/board/" + rs_fname_s + "' border='0' width='" + rs_fimage_w + "' align='right'>");
    
    rs_bcontent = rs_bcontent.replaceAll("@image@", url_path + "/upload/board/" + rs_fname_s);
    
  }
  
  rs_files_img.close();
}
// ------------------------------------------------------------------------------------------------------

%>



<script language="JavaScript">
<!--

function fun_list()
{
  var form = document.board_form;
  form.action = "program.action"
  
  form.method.value = "l";
  form.submit();
}

function fun_prv(idx)
{
  var form = document.board_form;
  form.action = "program.action"
  
  form.method.value = "v";
  form.idx.value = idx;
  form.submit();
}

function fun_next(idx)
{
  var form = document.board_form;
  form.action = "program.action"
  
  form.method.value = "v";
  form.idx.value = idx;
  form.submit();
}


// 파일 다운로드
function fun_download(idx)
{
  var form = document.download_form;
  form.action = "/upload/download_unify.jsp"
  
  form.idx.value = idx;
  
  form.submit();
}

    
//-->
</script>


<form name="board_form" method="post" action="program.action">

<input type="hidden" name="method"    value="">
<input type="hidden" name="target"    value="<%=rq_target%>">
<input type="hidden" name="cmsid"     value="<%=rq_cid%>">
<input type="hidden" name="bidx"      value="<%=rs_seqid%>">
<input type="hidden" name="nickname"  value="<%=rq_nickname%>">
<input type="hidden" name="idx"       value="<%=rq_idx%>">
<input type="hidden" name="mode"      value="">


<input type="hidden" name="page"      value="<%=rq_page%>">
<input type="hidden" name="st"        value="<%=rq_search_type%>">
<input type="hidden" name="sk"        value="<%=rq_search_key%>">

<input type="hidden" name="b_ref"     value="<%=rs_bref%>">
<input type="hidden" name="b_step"    value="<%=rs_bstep%>">
<input type="hidden" name="b_level"   value="<%=rs_blevel%>">

<input type="submit" value="" class="HIDE" />

</form>


<form name="download_form" method="post" action="program.action">

<input type="hidden" name="cmsid"     value="<%=rs_cid%>">
<input type="hidden" name="bidx"      value="<%=rs_seqid%>">
<input type="hidden" name="idx"       value="<%=rq_idx%>">

<input type="submit" value="" class="HIDE" />

</form>


<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<div class="wrap">
  
  <div class="view_table data_tables">

    <table>
      <tr class="first_line">
        <th scope="row" width="20%" class="first_cell">작성자</th>
        <td width="" ><%=writer_str%></td>
        <th scope="row" width="20%" >작성일</th>
        <td width="" ><%=rs_inst_date%></td>
      </tr>
      
      <tr>
        <th scope="row" width="205">제 목</th>
        <td width="" colspan="3"><%=rs_bsubject%></td>
      </tr>
      
      <tr><td colspan="4" style="padding-bottom:50px;"><%=rs_bcontent%></td></tr>

                
      <%
      if(record_file_count > 0)
      {
      %>
     
      <tr>
        <th scope="row" width="20%">첨부파일</th>
        <td width="" colspan="3" >
                      &nbsp;&nbsp;
                      <%
                      while(rs_files.next())
                      {
                        rs_fidx    = rs_files.getInt(1);
                        rs_fname_o = rs_files.getString(2);
                        rs_fname_s = rs_files.getString(3);
                        
                        out.println("<a href='/upload/download_unify.jsp?cmsid=" + rs_cid + "&bidx=" + rs_seqid + "&idx=" + rs_fidx + "'>" + rs_fname_o + "</a>");
                      }
                      
                      rs_files.close();
                      
                      %>
                  </td>
                </tr>
                <%
                }
                %>
                
         <div class="width100per t_right margin_top10px">
                <%
                if(!rs_prv_bsubject.equals(""))
                {
                %>
                
                <tr class="last_line left_bar">
                  <th scope="row" width='20%'>이전글</th>
                  <td><a href="program.action?<%=req_unify_str%>&method=v&idx=<%=rs_prv_seqid%>&page=<%=rq_page%>"><%=rs_prv_bsubject%></a></td>
                </tr>
                
                <%
                }
                
                if(!rs_next_bsubject.equals(""))
                {
                %>
                
               <tr class="left_bar">
                  <th scope="row" width="20%">다음글</th>
                  <td><a href="program.action?<%=req_unify_str%>&method=v&idx=<%=rs_next_seqid%>&page=<%=rq_page%>"><%=rs_next_bsubject%></a></td>
                </tr>
                
                <%
                }
                %>
                

                
              </table>

		<div class='button deep_blue'><a href="board.action?<%=req_unify_str%>&method=l&idx=&page=<%=rq_page%>">목록</a></div>
		 </div>


</div>

</div>


<%

if(stl!=null) { 
 stl.close(); 
 stl = null;
}

%>