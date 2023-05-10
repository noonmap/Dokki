package com.dokki.book.dto.response;


import com.dokki.util.common.utils.FileUtils;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Slice;


@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookSearchResponseDto {

	private String bookId;
	private String bookTitle;
	private String bookAuthor;
	private String bookCoverPath;
	private String bookPublishYear;
	private String bookPublisher;


	private static BookSearchResponseDto fromItem(AladinItemResponseDto item) {
		String year = Integer.toString(item.getPubDate().getYear());    // date to year (string)
		return BookSearchResponseDto.builder()
			.bookId(item.getIsbn13())
			.bookTitle(item.getTitle())
			.bookAuthor(item.getAuthor())
			.bookCoverPath(FileUtils.getAbsoluteFilePath(item.getCover()))
			.bookPublishYear(year)
			.bookPublisher(item.getPublisher())
			.build();
	}


	public static Slice<BookSearchResponseDto> toSliceFromApiResponse(Slice<AladinItemResponseDto> aladinItemsSlice) {
		return aladinItemsSlice.map(BookSearchResponseDto::fromItem);
	}

}
