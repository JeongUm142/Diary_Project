package vo;
// notice 테이블의 한행(레코드)를 저장하는 용도 
// Value Object or Data Transfer Object or Domain 타입
public class Notice {
		//db에서는 _, 여기서는 대문자
	//notice값을 지정해두고 list에서 불러올 예정
	public int noticeNo;
	public String noticeTitle;
	public String noticeContent;
	public String noticeWriter;
	public String createdate;
	public String updatedate;
	public String noticePw;

}
