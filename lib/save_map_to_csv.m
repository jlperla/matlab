%This utility is intended to be used with the etk latex macros for embedding computed parameters throughout a document.
function save_map_to_csv(S, filename, base_digits)
    if(nargin < 3)
        base_digits = 2;
    end
    %The SaveMap expects S is a structure with only scalar values.
    %This isn't very safe or robust to misuse right now.
    str = ['Key,Value' 10];
%    cr = sprintf('\n'); % A carriage return.  If using on linux, this might be better to generalize as a parameter
    
    %For each fieldname, get it and append to the text.
    fields = fieldnames(S);
    for i=1:length(fields)
        field = fields{i};
        if(~strcmp(field(1:min(length(field),7)),'format_')) %format_ fields are special.
            fieldvalue = getfield(S,field);
            fieldvaluestr = '';
            %Need to determine type to put to the file properly
            has_format = isfield(S,strcat('format_',field));
            if(has_format)
                fieldvaluestr = sprintf(getfield(S,strcat('format_',field)),fieldvalue); %Getting format for the field.
            elseif(isnumeric(fieldvalue))
                fieldvaluestr = sprintf(strcat('%0.',int2str(base_digits),'f'),fieldvalue);
            elseif (isstr(fieldvalue))
                fieldvaluestr = sprintf('%s',fieldvalue);
            end
            str = [str field ',' fieldvaluestr 10];
    %        str = strcat(str, field, ',', fieldvaluestr, cr);
        end
    end
    
    %Writes the string to the file.
    f=fopen(filename, 'w+');
    if(f == -1)
       disp([filename ' cannot be opened to write.  It is likely open in another program']);
    else
        fwrite(f,str,'char');
        fclose(f);    
    end
end