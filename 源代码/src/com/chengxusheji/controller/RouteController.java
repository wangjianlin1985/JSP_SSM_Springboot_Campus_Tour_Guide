package com.chengxusheji.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.chengxusheji.utils.ExportExcelUtil;
import com.chengxusheji.utils.UserException;
import com.chengxusheji.service.RouteService;
import com.chengxusheji.po.Route;
import com.chengxusheji.service.ScenicService;
import com.chengxusheji.po.Scenic;

//Route管理控制层
@Controller
@RequestMapping("/Route")
public class RouteController extends BaseController {

    /*业务层对象*/
    @Resource RouteService routeService;

    @Resource ScenicService scenicService;
	@InitBinder("startScenic")
	public void initBinderstartScenic(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("startScenic.");
	}
	@InitBinder("endScenic")
	public void initBinderendScenic(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("endScenic.");
	}
	@InitBinder("route")
	public void initBinderRoute(WebDataBinder binder) {
		binder.setFieldDefaultPrefix("route.");
	}
	/*跳转到添加Route视图*/
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String add(Model model,HttpServletRequest request) throws Exception {
		model.addAttribute(new Route());
		/*查询所有的Scenic信息*/
		List<Scenic> scenicList = scenicService.queryAllScenic();
		request.setAttribute("scenicList", scenicList);
		return "Route_add";
	}

	/*客户端ajax方式提交添加路径信息*/
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public void add(@Validated Route route, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
		boolean success = false;
		if (br.hasErrors()) {
			message = "输入信息不符合要求！";
			writeJsonResponse(response, success, message);
			return ;
		}
        routeService.addRoute(route);
        message = "路径添加成功!";
        success = true;
        writeJsonResponse(response, success, message);
	}
	/*ajax方式按照查询条件分页查询路径信息*/
	@RequestMapping(value = { "/list" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void list(@ModelAttribute("startScenic") Scenic startScenic,@ModelAttribute("endScenic") Scenic endScenic,Integer page,Integer rows, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		if (page==null || page == 0) page = 1;
		if(rows != 0)routeService.setRows(rows);
		List<Route> routeList = routeService.queryRoute(startScenic, endScenic, page);
	    /*计算总的页数和总的记录数*/
	    routeService.queryTotalPageAndRecordNumber(startScenic, endScenic);
	    /*获取到总的页码数目*/
	    int totalPage = routeService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = routeService.getRecordNumber();
        response.setContentType("text/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象
		JSONObject jsonObj=new JSONObject();
		jsonObj.accumulate("total", recordNumber);
		JSONArray jsonArray = new JSONArray();
		for(Route route:routeList) {
			JSONObject jsonRoute = route.getJsonObject();
			jsonArray.put(jsonRoute);
		}
		jsonObj.accumulate("rows", jsonArray);
		out.println(jsonObj.toString());
		out.flush();
		out.close();
	}

	/*ajax方式按照查询条件分页查询路径信息*/
	@RequestMapping(value = { "/listAll" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void listAll(HttpServletResponse response) throws Exception {
		List<Route> routeList = routeService.queryAllRoute();
        response.setContentType("text/json;charset=UTF-8"); 
		PrintWriter out = response.getWriter();
		JSONArray jsonArray = new JSONArray();
		for(Route route:routeList) {
			JSONObject jsonRoute = new JSONObject();
			jsonRoute.accumulate("routeId", route.getRouteId());
			jsonRoute.accumulate("routeId", route.getRouteId());
			jsonArray.put(jsonRoute);
		}
		out.println(jsonArray.toString());
		out.flush();
		out.close();
	}

	/*前台按照查询条件分页查询路径信息*/
	@RequestMapping(value = { "/frontlist" }, method = {RequestMethod.GET,RequestMethod.POST})
	public String frontlist(@ModelAttribute("startScenic") Scenic startScenic,@ModelAttribute("endScenic") Scenic endScenic,Integer currentPage, Model model, HttpServletRequest request) throws Exception  {
		if (currentPage==null || currentPage == 0) currentPage = 1;
		List<Route> routeList = routeService.queryRoute(startScenic, endScenic, currentPage);
	    /*计算总的页数和总的记录数*/
	    routeService.queryTotalPageAndRecordNumber(startScenic, endScenic);
	    /*获取到总的页码数目*/
	    int totalPage = routeService.getTotalPage();
	    /*当前查询条件下总记录数*/
	    int recordNumber = routeService.getRecordNumber();
	    request.setAttribute("routeList",  routeList);
	    request.setAttribute("totalPage", totalPage);
	    request.setAttribute("recordNumber", recordNumber);
	    request.setAttribute("currentPage", currentPage);
	    request.setAttribute("startScenic", startScenic);
	    request.setAttribute("endScenic", endScenic);
	    List<Scenic> scenicList = scenicService.queryAllScenic();
	    request.setAttribute("scenicList", scenicList);
		return "Route/route_frontquery_result"; 
	}

     /*前台查询Route信息*/
	@RequestMapping(value="/{routeId}/frontshow",method=RequestMethod.GET)
	public String frontshow(@PathVariable Integer routeId,Model model,HttpServletRequest request) throws Exception {
		/*根据主键routeId获取Route对象*/
        Route route = routeService.getRoute(routeId);

        List<Scenic> scenicList = scenicService.queryAllScenic();
        request.setAttribute("scenicList", scenicList);
        request.setAttribute("route",  route);
        return "Route/route_frontshow";
	}
	
	
	 /*前台查询Route信息*/
	@RequestMapping(value="/frontSearch",method=RequestMethod.POST)
	public String frontshow(Route route,Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		/*根据主键routeId获取Route对象*/
        int startScenicId = route.getStartScenic().getScenicId();
        int endScenicId = route.getEndScenic().getScenicId();
        Scenic startScenic = scenicService.getScenic(startScenicId);
        Scenic endScenic = scenicService.getScenic(endScenicId); 
        request.setAttribute("startScenic",  startScenic);
        request.setAttribute("endScenic",  endScenic);
        return "Route/route_frontSearch";
	}

	
	

	/*ajax方式显示路径修改jsp视图页*/
	@RequestMapping(value="/{routeId}/update",method=RequestMethod.GET)
	public void update(@PathVariable Integer routeId,Model model,HttpServletRequest request,HttpServletResponse response) throws Exception {
        /*根据主键routeId获取Route对象*/
        Route route = routeService.getRoute(routeId);

        response.setContentType("text/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
		//将要被返回到客户端的对象 
		JSONObject jsonRoute = route.getJsonObject();
		out.println(jsonRoute.toString());
		out.flush();
		out.close();
	}

	/*ajax方式更新路径信息*/
	@RequestMapping(value = "/{routeId}/update", method = RequestMethod.POST)
	public void update(@Validated Route route, BindingResult br,
			Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
		String message = "";
    	boolean success = false;
		if (br.hasErrors()) { 
			message = "输入的信息有错误！";
			writeJsonResponse(response, success, message);
			return;
		}
		try {
			routeService.updateRoute(route);
			message = "路径更新成功!";
			success = true;
			writeJsonResponse(response, success, message);
		} catch (Exception e) {
			e.printStackTrace();
			message = "路径更新失败!";
			writeJsonResponse(response, success, message); 
		}
	}
    /*删除路径信息*/
	@RequestMapping(value="/{routeId}/delete",method=RequestMethod.GET)
	public String delete(@PathVariable Integer routeId,HttpServletRequest request) throws UnsupportedEncodingException {
		  try {
			  routeService.deleteRoute(routeId);
	            request.setAttribute("message", "路径删除成功!");
	            return "message";
	        } catch (Exception e) { 
	            e.printStackTrace();
	            request.setAttribute("error", "路径删除失败!");
				return "error";

	        }

	}

	/*ajax方式删除多条路径记录*/
	@RequestMapping(value="/deletes",method=RequestMethod.POST)
	public void delete(String routeIds,HttpServletRequest request,HttpServletResponse response) throws IOException, JSONException {
		String message = "";
    	boolean success = false;
        try { 
        	int count = routeService.deleteRoutes(routeIds);
        	success = true;
        	message = count + "条记录删除成功";
        	writeJsonResponse(response, success, message);
        } catch (Exception e) { 
            //e.printStackTrace();
            message = "有记录存在外键约束,删除失败";
            writeJsonResponse(response, success, message);
        }
	}

	/*按照查询条件导出路径信息到Excel*/
	@RequestMapping(value = { "/OutToExcel" }, method = {RequestMethod.GET,RequestMethod.POST})
	public void OutToExcel(@ModelAttribute("startScenic") Scenic startScenic,@ModelAttribute("endScenic") Scenic endScenic, Model model, HttpServletRequest request,HttpServletResponse response) throws Exception {
        List<Route> routeList = routeService.queryRoute(startScenic,endScenic);
        ExportExcelUtil ex = new ExportExcelUtil();
        String title = "Route信息记录"; 
        String[] headers = { "起始景点","结束景点"};
        List<String[]> dataset = new ArrayList<String[]>(); 
        for(int i=0;i<routeList.size();i++) {
        	Route route = routeList.get(i); 
        	dataset.add(new String[]{route.getStartScenic().getScenicName(),route.getEndScenic().getScenicName()});
        }
        /*
        OutputStream out = null;
		try {
			out = new FileOutputStream("C://output.xls");
			ex.exportExcel(title,headers, dataset, out);
		    out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		*/
		OutputStream out = null;//创建一个输出流对象 
		try { 
			out = response.getOutputStream();//
			response.setHeader("Content-disposition","attachment; filename="+"Route.xls");//filename是下载的xls的名，建议最好用英文 
			response.setContentType("application/msexcel;charset=UTF-8");//设置类型 
			response.setHeader("Pragma","No-cache");//设置头 
			response.setHeader("Cache-Control","no-cache");//设置头 
			response.setDateHeader("Expires", 0);//设置日期头  
			String rootPath = request.getSession().getServletContext().getRealPath("/");
			ex.exportExcel(rootPath,title,headers, dataset, out);
			out.flush();
		} catch (IOException e) { 
			e.printStackTrace(); 
		}finally{
			try{
				if(out!=null){ 
					out.close(); 
				}
			}catch(IOException e){ 
				e.printStackTrace(); 
			} 
		}
    }
}
