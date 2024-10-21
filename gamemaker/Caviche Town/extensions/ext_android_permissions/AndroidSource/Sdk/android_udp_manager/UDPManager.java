package ${YYAndroidPackageName};

import $

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.nio.ByteBuffer;

import com.yoyogames.runner.RunnerJNILib;


//https://developer.android.com/reference/android/webkit/WebView
public class UDPManager
{

	private volatile bool keepReceiving = false;
	private volatile String lastReceived = null;
	private Thread receiverThread = null;

	private class ReceivingRunnable implements Runnable {

		int port;

		ReceivingRunnable(int port) {
			this.port = port;
		}

		@Override
		public void run() {

			try {

				DatagramSocket socket = new DatagramSocket(port, InetAddress.getByName("0.0.0.0"));

				while (keepReceiving) {
					byte[] buffer = new byte[1024];
					DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
					socket.receive(packet);

					String message = new String(packet.getData(), 0, packet.getLength());
					lastReceived = message;
				}

			} catch (Exception e) {
				// TODO: handle exception
			}
		}
	}

	public String receive() {
		if (lastReceived != null) {
			String result = lastReceived;
			lastReceived = null;
			return result;
		} else {
			return null;
		}
	}

	public void stopBroadcastReceiving() {
		keepReceiving = false;
	}

	public void startBroadcastReceiving(int port) {
		if (receiverThread == null) {
			keepReceiving = true;
			ReceivingRunnable receivingRunnable = new ReceivingRunnable(port);
			receiverThread = new Thread(receivingRunnable);
			receiverThread.start();
		}
	}
	
}	
