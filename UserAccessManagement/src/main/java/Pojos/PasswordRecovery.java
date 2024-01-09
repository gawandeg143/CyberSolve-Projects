package Pojos;

public class PasswordRecovery {
	
	private int id;
	private String user;
	private String question;
	private String answer;
	
	public PasswordRecovery() {
		super();
	}

	public PasswordRecovery(int id, String user, String question, String answer) {
		super();
		this.id = id;
		this.user = user;
		this.question = question;
		this.answer = answer;
	}

	public PasswordRecovery(String user, String question, String answer) {
		super();
		this.user = user;
		this.question = question;
		this.answer = answer;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	@Override
	public String toString() {
		return "PasswordRecovery [id=" + id + ", userId=" + user + ", question=" + question + ", answer=" + answer
				+ "]";
	}

}
