<%@ page contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>

<%

String inc_rq_cid    = str_util.getArgsCheck(request.getParameter("cmsid"));
String inc_rq_method = str_util.getArgsCheck(request.getParameter("method"));
String inc_rq_idx    = str_util.getArgsCheck(request.getParameter("idx"));

if(inc_rq_cid == null || inc_rq_cid.equals("")) inc_rq_cid = "";
if(inc_rq_method == null || inc_rq_method.equals("")) inc_rq_method = "";
if(inc_rq_idx == null || inc_rq_idx.equals("")) inc_rq_idx = "";

// 숫자형 아니면 null 처리
if(inc_rq_idx.length() > 20 || !inc_rq_idx.equals("")) { if(!str_util.isNumeric(inc_rq_idx)) inc_rq_idx = ""; }


String inc_login_id = "";
String inc_login_class = "guest";
String inc_sql = "";


String rs_inc_btype = "0";
String rs_inc_bsecret_view = "0";
String rs_inc_bsecret_list = "0";
String rs_inc_btitle_img = "";
String rs_inc_blogin_img = "";
String rs_inc_btitle_img_alt = "";
String rs_inc_blogin_img_alt = "";
String rs_inc_bclass = "0";
String rs_inc_bfile = "0";
int rs_inc_bfile_num = 0;
int rs_inc_bfile_size = 0;

String rs_inc_al = "0";
String rs_inc_av = "0";
String rs_inc_aw = "0";
String rs_inc_ar = "0";
String rs_inc_am = "0";
String rs_inc_ad = "0";
String rs_inc_am_r = "0";
String rs_inc_ad_r = "0";

String rs_inc_bu_id = "";
String rs_inc_bsecret = "";
String rs_inc_bu_id_r = "";
String rs_inc_bsecret_r = "";

String inc_admin = "";


// 관리자 인지 확인
if(session.getAttribute("session_login_id") != null && session.getAttribute("session_login_class").equals("admin"))
{
  inc_admin = "OK";
}
else
{
  inc_admin = "";
}


// -----------------------------------------------------------------------------
// 게시판 정보
// -----------------------------------------------------------------------------
inc_sql = "";
inc_sql = inc_sql + "select ";
inc_sql = inc_sql + "btype, bsecret_view, bsecret_list, btitle_img, blogin_img, btitle_img_alt, blogin_img_alt, ";
inc_sql = inc_sql + "bclass, bfile, bfile_num, bfile_size ";
inc_sql = inc_sql + "from board_control where cid = '" + inc_rq_cid + "'";

ResultSet rs_board_ctl = stl.executeQuery(inc_sql);

if(rs_board_ctl.next())
{
  rs_inc_btype          = rs_board_ctl.getString(1);
  rs_inc_bsecret_view   = rs_board_ctl.getString(2);
  rs_inc_bsecret_list   = rs_board_ctl.getString(3);
  rs_inc_btitle_img     = rs_board_ctl.getString(4);
  rs_inc_blogin_img     = rs_board_ctl.getString(5);
  rs_inc_btitle_img_alt = rs_board_ctl.getString(6);
  rs_inc_blogin_img_alt = rs_board_ctl.getString(7);
  rs_inc_bclass         = rs_board_ctl.getString(8);
  rs_inc_bfile          = rs_board_ctl.getString(9);
  rs_inc_bfile_num      = rs_board_ctl.getInt(10);
  rs_inc_bfile_size     = rs_board_ctl.getInt(11);
  
  if(rs_inc_btitle_img_alt == null) rs_inc_btitle_img_alt = "";
  if(rs_inc_blogin_img_alt == null) rs_inc_blogin_img_alt = "";
}

rs_board_ctl.close();


// -----------------------------------------------------------------------------
// 게시판 글쓴이, 비밀글 정보
// -----------------------------------------------------------------------------
//if(inc_rq_method != null)
//{
  //if(!inc_rq_method.equals("l") && inc_rq_idx != null)
  if(inc_rq_idx != null && !inc_rq_idx.equals(""))
  {
    inc_sql = "";
    inc_sql = inc_sql + "select bu_id, bsecret ";
    inc_sql = inc_sql + "from board where cid = '" + inc_rq_cid + "' and seqid = " + inc_rq_idx;
    ResultSet rs_board_dat = stl.executeQuery(inc_sql);
    if(rs_board_dat.next())
    {
      rs_inc_bu_id   = rs_board_dat.getString(1);
      rs_inc_bsecret = rs_board_dat.getString(2);
      
      if(rs_inc_bu_id == null) rs_inc_bu_id = "";
    }
    rs_board_dat.close();
    
    // 답변형 게시판 일때
    if(rs_inc_btype.equals("2"))
    {
      inc_sql = "";
      inc_sql = inc_sql + "select bu_id, bsecret ";
      inc_sql = inc_sql + "from board where cid = '" + inc_rq_cid + "' and bref = " + inc_rq_idx + " and blevel = 1 and bstep = 1";
      ResultSet rs_board_dat2 = stl.executeQuery(inc_sql);
      if(rs_board_dat2.next())
      {
        rs_inc_bu_id_r   = rs_board_dat2.getString(1);
        rs_inc_bsecret_r = rs_board_dat2.getString(2);
        
        if(rs_inc_bu_id_r == null) rs_inc_bu_id_r = "";
      }
      rs_board_dat2.close();
    }
    
  }
//}


// -----------------------------------------------------------------------------
// 게시판 사용권한
// -----------------------------------------------------------------------------

if(session.getAttribute("session_login_id") != null)
{
  inc_login_id    = session.getAttribute("session_login_id").toString();
  inc_login_class = session.getAttribute("session_login_class").toString();
}

// 관리자
if(!inc_admin.equals(""))
{
  rs_inc_al = "1";
  rs_inc_av = "1";
  rs_inc_aw = "1";
  rs_inc_ar = "1";
  rs_inc_am = "1";
  rs_inc_ad = "1";
  rs_inc_am_r = "1";
  rs_inc_ad_r = "1";
}
// 일반사용자
else
{
  inc_sql = "";
  inc_sql = inc_sql + "select al, av, aw, ar, am, ad ";
  inc_sql = inc_sql + "from authority_user where cid = '" + inc_rq_cid + "' and ccode = '" + inc_login_class + "'";
  ResultSet rs_aut_usr = stl.executeQuery(inc_sql);
  if(rs_aut_usr.next())
  {
    rs_inc_al = rs_aut_usr.getString(1);
    rs_inc_av = rs_aut_usr.getString(2);
    rs_inc_aw = rs_aut_usr.getString(3);
    rs_inc_ar = rs_aut_usr.getString(4);
    rs_inc_am = rs_aut_usr.getString(5);
    rs_inc_ad = rs_aut_usr.getString(6);
  }
  else
  {
    // 저장된 사용자권한 기록이 없을때 (초기값 반영)
    rs_inc_al = "1";
    rs_inc_av = "0";
    rs_inc_aw = "0";
    rs_inc_ar = "0";
    rs_inc_am = "0";
    rs_inc_ad = "0";
  }
  rs_aut_usr.close();
  
  // 글목록 로그인 후 공개 + 로그인 않했을때
  if((rs_inc_bsecret_list.equals("1") || rs_inc_bsecret_list.equals("2")) && session.getAttribute("session_login_id") == null)
  {
    rs_inc_al = "0";
  }
  // 비공개
  else if(rs_inc_bsecret_list.equals("3"))
  {
    rs_inc_al = "0";
  }
  
  // 공지형 게시판은 글작성 않됨
  //if(rs_inc_btype.equals("0")) rs_inc_aw = "0";
  
  // 로그인 + 본인이 작성한 글
  if(session.getAttribute("session_login_id") != null && (rs_inc_bu_id.equals(session.getAttribute("session_login_id")) || rs_inc_bu_id_r.equals(session.getAttribute("session_login_id"))))
  {
    rs_inc_av = "1";
    
    // 글(질문)
    /*
    if(rs_inc_bu_id.equals(session.getAttribute("session_login_id")))
    {
      if(rs_inc_am.equals("1")) rs_inc_am = "1";
      if(rs_inc_ad.equals("1")) rs_inc_ad = "1";
    }
    else
    {
      rs_inc_am = "0";
      rs_inc_ad = "0";
    }
    */
    
    // 답변
    if(rs_inc_bu_id_r.equals(session.getAttribute("session_login_id")))
    {
      // 수정권한 있을때만 답변 수정 가능
      if(rs_inc_am.equals("1")) { rs_inc_am_r = "1"; }
      else { rs_inc_am_r = "0"; }
      
      // 삭제권한 있을때만 답변 삭제 가능
      if(rs_inc_ad.equals("1")) { rs_inc_ad_r = "1"; }
      else { rs_inc_ad_r = "0"; }
      
      //out.println(rs_inc_am + "/" + rs_inc_ad);
      //out.println(rs_inc_am_r + "/" + rs_inc_ad_r);
    }
  }
  // 로그아웃 또는 본인이 작성 않한 글
  else
  {
    // 사용자 선택 + 작성자가 비밀글 선택
    if(rs_inc_bsecret_view.equals("1") && rs_inc_bsecret.equals("1"))
    {
      rs_inc_av = "0";
    }
    // 비밀글
    else if(rs_inc_bsecret_view.equals("2"))
    {
      rs_inc_av = "0";
    }
    
    // 비회원이 작성한 글
    if(rs_inc_bu_id.equals(""))
    {
      //rs_inc_av = "1";
      //rs_inc_am = "1";
      //rs_inc_ad = "1";
    }
    // 회원이 작성한 글
    else
    {
      rs_inc_am = "0";
      rs_inc_ad = "0";
    }
    
  }
  
}
/*
out.println("cid : " +inc_rq_cid + "</br>");
out.println("method : " +inc_rq_method  + "</br>");
out.println("idx : " +inc_rq_idx  + "</br>");
out.println("admin: " + inc_admin + "</br>");

out.println("admin : " +session.getAttribute("session_login_admin") + "<br>");
out.println("id : " +session.getAttribute("session_login_id") + "<br>");
out.println("class : " +session.getAttribute("session_login_class") + "<br>");
out.println("u_cd : " +session.getAttribute("session_login_user_cd") + "<br>");
out.println("u_nm : " +session.getAttribute("session_login_user_nm") + "<br>");
out.println("d_cd : " +session.getAttribute("session_login_dept_cd") + "<br>");
out.println("d_nm : " +session.getAttribute("session_login_dept_nm") + "<br>");

out.println("list : " + rs_inc_al + "<br>");
out.println("view : " +rs_inc_av+ "<br>");
out.println("write : " +rs_inc_aw + "<br>");
out.println("reply : " +rs_inc_ar + "<br>");
out.println("modify : " +rs_inc_am + "<br>");
out.println("delete : " +rs_inc_ad + "<br>");
out.println("am_r : " +rs_inc_am_r + "<br>");
out.println("ad_r : " +rs_inc_ad_r + "<br>");
*/
%>