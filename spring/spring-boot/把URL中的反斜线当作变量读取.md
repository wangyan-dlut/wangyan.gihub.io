```
@RequestMapping(value = "/download/{value1}/**", method = RequestMethod.GET)  
public void getValue(@PathVariable String value1, HttpServletRequest request) throws CommonException {  
String value = extractPathFromPattern(request);  
}  
  
  
  
  
private String extractPathFromPattern(final HttpServletRequest request) {  
String path = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);  
String bestMatchPattern = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);  
return new AntPathMatcher().extractPathWithinPattern(bestMatchPattern, path);  
}  
```