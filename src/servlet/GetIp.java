package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import remoteconnect.TestRemoteConnect;

public class GetIp extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public GetIp() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setContentType("text/html;charset=utf-8");
	    PrintWriter out = response.getWriter();
	    System.out.println("get!!");
	    out.println("get");
    }
	
	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(final HttpServletRequest request, final HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html;charset=UTF-8");
		String ip = request.getParameter("ip");
		String username = request.getParameter("username");
		String password = request.getParameter("password");

		ArrayList<Float> list = TestRemoteConnect.getCpuAndMem(ip,username,password);
		
		PrintWriter out;
		out = response.getWriter();
        // Write some content
       if(list.size()==0){
    	   out.print("error");
       }else{
    	   out.print(list.get(0)+"&"+list.get(1));
       }
       //System.out.println(out);
        out.close();
		
	}

	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
