// For javax.mail.* libraries - download javax.mail.jar and place it in the build-path
// Also, in your mail's security settings, enable "Access for less secure apps"
//     http://stackoverflow.com/questions/20337040/gmail-smtp-debug-error-please-log-in-via-your-web-browser
import java.util.*;

import javax.mail.*;

	public class EmailReader4 {
	    public static void main(String[] args) {
	    	
	    	System.out.println("Hello - starting the run now ");
	    	
	    	Properties mailProperties = new Properties();
	    	mailProperties.setProperty("mail.store.protocol", "imaps");
	    	//mailProperties.setProperty("mail.imaps.host", "imap.gmail.com");
	    	//mailProperties.setProperty("mail.imaps.port", "993");
	    	//mailProperties.setProperty("mail.imaps.connectiontimeout", "5000");
	    	//mailProperties.setProperty("mail.imaps.timeout", "5000");
	    	//mailProperties.setProperty("mail.imap.ssl.enable", "true");
	    	
	    	try {
	    		Session mailSession = Session.getInstance(mailProperties, null);
	    		
	    		// URL Way - somehow did not work - said 'failed to connect, no password specified'
		    	//URLName urlName = new URLName("imap://my@gmail.com:MYPASSWORD@imap.gmail.com");
		    	//Store mailStore = mailSession.getStore(urlName);
	    		
		    	Store mailStore   = mailSession.getStore();
		    	
		    	System.out.println("Got the store ");
		    	
		    	mailStore.connect("imap.gmail.com", "myemail@gmail.com", "mypassword");

		    	mailStore.close();
		    	mailStore.connect();
		    	
		    	System.out.println("Got connected ");
		    	
		    	Folder inbox = mailStore.getFolder("INBOX");
	            inbox.open(Folder.READ_ONLY);
	            Message msg = inbox.getMessage(inbox.getMessageCount());
	            Address[] in = msg.getFrom();
	            for (Address address : in) {
	                System.out.println("FROM:" + address.toString());
	            }
	            Multipart mp = (Multipart) msg.getContent();
	            BodyPart bp = mp.getBodyPart(0);
	            System.out.println("SENT DATE:" + msg.getSentDate());
	            System.out.println("SUBJECT:" + msg.getSubject());
	            System.out.println("CONTENT:" + bp.getContent());
		    	
	    	} catch (Exception mex) {
	            mex.printStackTrace();
	        }
	    	
	    	
	    }
	}
