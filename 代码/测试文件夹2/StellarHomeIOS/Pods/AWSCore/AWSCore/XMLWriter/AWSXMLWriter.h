#import <Foundation/Foundation.h>
@protocol AWSXMLStreamWriter
- (void) writeStartDocument;
- (void) writeStartDocumentWithVersion:(NSString*)version;
- (void) writeStartDocumentWithEncodingAndVersion:(NSString*)encoding version:(NSString*)version;
- (void) writeStartElement:(NSString *)localName;
- (void) writeEndElement; 
- (void) writeEndElement:(NSString *)localName;
- (void) writeEmptyElement:(NSString *)localName;
- (void) writeEndDocument; 
- (void) writeAttribute:(NSString *)localName value:(NSString *)value;
- (void) writeCharacters:(NSString*)text;
- (void) writeComment:(NSString*)comment;
- (void) writeProcessingInstruction:(NSString*)target data:(NSString*)data;
- (void) writeCData:(NSString*)cdata;
- (NSMutableString*) toString;
- (NSData*) toData;
- (void) flush;
- (void) close;
@end
@protocol AWSNSXMLStreamWriter <AWSXMLStreamWriter>
- (void) writeStartElementWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName;
- (void) writeEndElementWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName;
- (void) writeEmptyElementWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName;
- (void) writeAttributeWithNamespace:(NSString *)namespaceURI localName:(NSString *)localName value:(NSString *)value;
- (void)setPrefix:(NSString*)prefix namespaceURI:(NSString *)namespaceURI;
- (void) writeNamespace:(NSString*)prefix namespaceURI:(NSString *)namespaceURI;
- (void)setDefaultNamespace:(NSString*)namespaceURI;
- (void) writeDefaultNamespace:(NSString*)namespaceURI;
- (NSString*)getPrefix:(NSString*)namespaceURI;
- (NSString*)getNamespaceURI:(NSString*)prefix;
@end
@interface AWSXMLWriter : NSObject <AWSNSXMLStreamWriter> {
	NSMutableString* writer;
	NSString* encoding;
	int level;
	BOOL openElement;
	BOOL emptyElement;
	NSMutableArray* elementLocalNames;
	NSMutableArray* elementNamespaceURIs;
	NSMutableArray* namespaceURIs;
	NSMutableArray* namespaceCounts;
	NSMutableArray* namespaceWritten;
	NSMutableDictionary* namespaceURIPrefixMap;
	NSMutableDictionary* prefixNamespaceURIMap;
	NSString* indentation;
	NSString* lineBreak;
	BOOL automaticEmptyElements;
}
@property (nonatomic, strong, readwrite) NSString* indentation;
@property (nonatomic, strong, readwrite) NSString* lineBreak;
@property (nonatomic, assign, readwrite) BOOL automaticEmptyElements;
@property (nonatomic, readonly) int level;
- (void) writeLinebreak;
- (void) writeIndentation;
- (void) writeCloseStartElement;
- (void) writeNamespaceAttributes;
- (void) writeEscape:(NSString*)value;
- (void) write:(NSString*)value;
@end