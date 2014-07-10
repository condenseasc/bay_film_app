class Error < RuntimeError
end

class ValidationError < Error
end

class DuplicateRecordError < Error
end