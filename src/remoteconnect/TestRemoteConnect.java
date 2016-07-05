package remoteconnect;

/**
 * Created by Bertram on 16-6-16.
 */
import java.io.IOException;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

/*
  @author:
  purpose: test connecting remote computer and execute linux command
*/
public class TestRemoteConnect{
	
	static Connection conn=null;
	/**
	 * 
	 * @param hostname 要连接主机名
	 * @param username 用户名
	 * @param password 密码
	 */	
	public static boolean getConnect(String hostname,String username,String password){
		
		conn = new Connection(hostname,22);//22是默认端口号
		try{
			conn.connect();//连接主机
			boolean isconn = conn.authenticateWithPassword(username, password);//校验用户名和密码
			if(!isconn){
				return false;
			}else{
				return true;
			}
		} catch (IOException e) {
				return false;
		}
	}
	
	public static ArrayList<Float> getCpuAndMem(String hostname,String username,String password){
		ArrayList<Float>list=new ArrayList<Float>();
		Session ssh=null;
		boolean isconn = getConnect(hostname, username, password);
		if(!isconn){
			return list;
		}else{
			try {
				ssh = conn.openSession();
				ssh.execCommand("ps -aux");
				
				//将Terminal屏幕上的文字全部打印出来
				float cpu=0,mem=0;
                InputStream is = new StreamGobbler(ssh.getStdout());
                BufferedReader brs = new BufferedReader(new InputStreamReader(is));
                brs.readLine();//去掉第一行信息
                while (true)
                {
                    String line = brs.readLine();
                    if (line == null)
                    {
                        break;
                    }
//                    System.out.println(line);
//                    System.out.println(line.substring(16, 19));
//                    System.out.println(Float.parseFloat(line.substring(16, 19)));
//                    System.out.println(line.substring(21, 24));
//                    System.out.println(Float.parseFloat(line.substring(21, 24)));
                    cpu+= Float.parseFloat(line.substring(16, 19));
                    mem+=Float.parseFloat(line.substring(21, 24));
//                    System.out.println(cpu+"\t"+mem);
                }
//                System.out.println("cpu="+cpu+"%\tmem="+mem+"%");
//                System.out.println(list.size()+"!!!!!!!!!!!!!!!");
                list.add(cpu);
                list.add(mem);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally{
				//连接的Session和Connection对象都需要关闭
	            if(ssh!=null)
	            {
	                ssh.close();
	            }
	            if(conn!=null)
	            {
	                conn.close();
	            }
			}
		}
		return list;
	}
	
	
	public static void main(String args[]){
		getCpuAndMem("192.168.1.100","zbc","240612");
	}
}
