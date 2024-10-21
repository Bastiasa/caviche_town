package ${YYAndroidPackageName};


import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.nio.ByteBuffer;
import android.util.Log;

import ${YYAndroidPackageName}.R;
import com.yoyogames.runner.RunnerJNILib;

public class UDPManager
{
	private static final int EV_ASYNC_NETWORKING_WEB = 68;

	protected volatile boolean keepReceiving = false;
	protected volatile Thread receiverThread = null;

	private class ReceivingRunnable implements Runnable {

		int port;

		ReceivingRunnable(int port) {
			this.port = port;
		}

		@Override
		public void run() {

			DatagramSocket socket = null;

			try {

				socket = new DatagramSocket(this.port, InetAddress.getByName("0.0.0.0"));

				Log.i("yoyo", "Broadcasting receiving started in port " + String.valueOf(this.port));

				while (keepReceiving) {
					byte[] buffer = new byte[1024];
					DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
					socket.receive(packet);

					String message = new String(packet.getData(), 0, packet.getLength());
					onMessageReceived(message, packet.getAddress().getHostAddress(), packet.getPort());

					Log.i("yoyo", "Broadcast message received from " + packet.getAddress().getHostAddress());
				}

			} catch (Exception e) {
				// TODO: handle exception
				Log.i("yoyo", "Broadcasting receiving failed. Message: " + e.getMessage());
			} finally {
				receiverThread = null;
				Log.i("yoyo", "Broadcasting receiving stopped");
				
				if (socket != null) {
					socket.close();
				}
			}
		}
	}

	protected void onMessageReceived(String message, String ip, int port) {

		int dsMapIndex = RunnerJNILib.jCreateDsMap(null, null, null);
		RunnerJNILib.DsMapAddString(dsMapIndex, "type", "udp_broadcast_received");
		RunnerJNILib.DsMapAddString(dsMapIndex, "message", message);
		RunnerJNILib.DsMapAddString(dsMapIndex, "ip", ip);
		RunnerJNILib.DsMapAddDouble(dsMapIndex, "port", (double) port);
		RunnerJNILib.CreateAsynEventWithDSMap(dsMapIndex, EV_ASYNC_NETWORKING_WEB);
	}

	public String stopBroadcastReceiving() {
		keepReceiving = false;
		Log.i("yoyo", "Broadcasting receiving stopping");
		return "";
	}

	public String startBroadcastReceiving(double port) {

		if (receiverThread == null) {
			keepReceiving = true;
			
			ReceivingRunnable receivingRunnable = new ReceivingRunnable((int) port);

			receiverThread = new Thread(receivingRunnable);
			receiverThread.start();
		}

		return "";
	}
	
}	
