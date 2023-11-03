package it.us.web.util;
import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;


public class Screenshot {

	public Screenshot() {
		
	}
	
	public BufferedImage takeBufferedScreenshot () throws Exception {
		
		Toolkit toolkit = Toolkit.getDefaultToolkit();
		Dimension screenSize = toolkit.getScreenSize();
		Robot robot = new Robot();
		
		Rectangle rectangle = new Rectangle(0, 0, screenSize.width-15, screenSize.height);
		BufferedImage image = robot.createScreenCapture(rectangle);
		
		return image;
	}
	
	public void takeScreenshot () throws Exception {
		
		Toolkit toolkit = Toolkit.getDefaultToolkit();
		Dimension screenSize = toolkit.getScreenSize();
		Robot robot = new Robot();
		
		Rectangle rectangle = new Rectangle(0, 0, screenSize.width-15, screenSize.height);
		BufferedImage image = robot.createScreenCapture(rectangle);
		
		ImageIO.write(image, "gif", new File("c:\\mmgg.jpg")); 
	}
	
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		Screenshot s = new Screenshot();
		s.takeScreenshot();
	}

}
