--- set print with parentheses on .
--- set print mixfix off .

	red		{
				type : "DOT", 
				children : [
					{type : "STRING", value : "person"}, 
					{type : "IDENTIFIER", value : "length"}
				]
			} 
	==Bool	staticAccess(s("person"),id("length")) .

	red		{
	        	type : "VAR",
            	children : [] ,
				destructurings : []
			} 
	==Bool	varDeclarations(.List{JS}) .
		
	red		{
	    type : "SCRIPT",
	    children : [
	        {
	            type : "VAR",
	            children : [
	                {
	                    type : "IDENTIFIER",
	                    children : [],
	                    end : 5,
	                    lineno : 1,
	                    name : "x",
	                    readOnly : false,
	                    start : 4,
	                    value : "x"
	                }
	            ],
	            destructurings : [],
	            end : 11,
	            lineno : 1,
	            start : 0,
	            value : "var"
	        }
	    ]
	}
	==Bool	program(varDeclarations(id("x"))) .
	
	red		{
        type : "SEMICOLON",
        children : [],
        end : 18,
        expression : {
            type : "ASSIGN",
            assignOp : null,
            children : [
                {
                    type : "IDENTIFIER",
                    children : [],
                    end : 14,
                    lineno : 2,
                    start : 13,
                    value : "x"
                },
                {
                    type : "NUMBER",
                    children : [],
                    end : 18,
                    lineno : 2,
                    start : 17,
                    value : 1
                }
            ],
            end : 18,
            lineno : 1,
            start : 11,
            value : ";"
        },
        lineno : 2,
        start : 13,
        value : "x"
    } 
	==Bool	exp(assignment(id("x"),null,n(1))) .

	red		{
	    type : "SCRIPT",
	    children : [
	        {
	            type : "VAR",
	            children : [
	                {
	                    type : "IDENTIFIER",
	                    children : [],
	                    end : 5,
	                    lineno : 1,
	                    name : "x",
	                    readOnly : false,
	                    start : 4,
	                    value : "x"
	                },
	                {
	                    type : "IDENTIFIER",
	                    children : [],
	                    end : 8,
	                    lineno : 1,
	                    name : "y",
	                    readOnly : false,
	                    start : 7,
	                    value : "y"
	                },
	                {
	                    type : "IDENTIFIER",
	                    children : [],
	                    end : 11,
	                    lineno : 1,
	                    name : "z",
	                    readOnly : false,
	                    start : 10,
	                    value : "z"
	                }
	            ],
	            destructurings : [],
	            end : 11,
	            lineno : 1,
	            start : 0,
	            value : "var"
	        },
	        {
	            type : "SEMICOLON",
	            children : [],
	            end : 18,
	            expression : {
	                type : "ASSIGN",
	                assignOp : null,
	                children : [
	                    {
	                        type : "IDENTIFIER",
	                        children : [],
	                        end : 14,
	                        lineno : 2,
	                        start : 13,
	                        value : "x"
	                    },
	                    {
	                        type : "NUMBER",
	                        children : [],
	                        end : 18,
	                        lineno : 2,
	                        start : 17,
	                        value : 1
	                    }
	                ],
	                end : 18,
	                lineno : 1,
	                start : 11,
	                value : ";"
	            },
	            lineno : 2,
	            start : 13,
	            value : "x"
	        },
	        {
	            type : "SEMICOLON",
	            children : [],
	            end : 25,
	            expression : {
	                type : "ASSIGN",
	                assignOp : null,
	                children : [
	                    {
	                        type : "IDENTIFIER",
	                        children : [],
	                        end : 21,
	                        lineno : 3,
	                        start : 20,
	                        value : "y"
	                    },
	                    {
	                        type : "NUMBER",
	                        children : [],
	                        end : 25,
	                        lineno : 3,
	                        start : 24,
	                        value : 2
	                    }
	                ],
	                end : 25,
	                lineno : 2,
	                start : 18,
	                value : ";"
	            },
	            lineno : 3,
	            start : 20,
	            value : "y"
	        },
	        {
	            type : "SEMICOLON",
	            children : [],
	            end : 40,
	            expression : {
	                type : "ASSIGN",
	                assignOp : null,
	                children : [
	                    {
	                        type : "IDENTIFIER",
	                        children : [],
	                        end : 28,
	                        lineno : 4,
	                        start : 27,
	                        value : "z"
	                    },
	                    {
	                        type : "PLUS",
	                        children : [
	                            {
	                                type : "INCREMENT",
	                                children : [
	                                    {
	                                        type : "IDENTIFIER",
	                                        children : [],
	                                        end : 32,
	                                        lineno : 4,
	                                        start : 31,
	                                        value : "x"
	                                    }
	                                ],
	                                end : 34,
	                                lineno : 4,
	                                postfix : true,
	                                start : 31,
	                                value : "++"
	                            },
	                            {
	                                type : "INCREMENT",
	                                children : [
	                                    {
	                                        type : "IDENTIFIER",
	                                        children : [],
	                                        end : 40,
	                                        lineno : 4,
	                                        start : 39,
	                                        value : "y"
	                                    }
	                                ],
	                                end : 40,
	                                lineno : 4,
	                                start : 37,
	                                value : "++"
	                            }
	                        ],
	                        end : 40,
	                        lineno : 4,
	                        start : 31,
	                        value : "+"
	                    }
	                ],
	                end : 40,
	                lineno : 3,
	                start : 25,
	                value : ";"
	            },
	            lineno : 4,
	            start : 27,
	            value : "z"
	        },
	        {
	            type : "SEMICOLON",
	            children : [],
	            end : 48,
	            expression : {
	                type : "ASSIGN",
	                assignOp : 24,
	                children : [
	                    {
	                        type : "IDENTIFIER",
	                        children : [],
	                        end : 43,
	                        lineno : 5,
	                        start : 42,
	                        value : "z"
	                    },
	                    {
	                        type : "NUMBER",
	                        children : [],
	                        end : 48,
	                        lineno : 5,
	                        start : 47,
	                        value : 3
	                    }
	                ],
	                end : 48,
	                lineno : 4,
	                start : 40,
	                value : ";"
	            },
	            lineno : 5,
	            start : 42,
	            value : "z"
	        }
	    ],
	    expDecls : [],
	    funDecls : [],
	    hasEmptyReturn : false,
	    hasReturnWithValue : false,
	    impDecls : [],
	    isGenerator : false,
	    lineno : 1,
	    varDecls : [
	        {
	            type : "IDENTIFIER",
	            children : [],
	            end : 5,
	            lineno : 1,
	            name : "x",
	            readOnly : false,
	            start : 4,
	            value : "x"
	        },
	        {
	            type : "IDENTIFIER",
	            children : [],
	            end : 8,
	            lineno : 1,
	            name : "y",
	            readOnly : false,
	            start : 7,
	            value : "y"
	        },
	        {
	            type : "IDENTIFIER",
	            children : [],
	            end : 11,
	            lineno : 1,
	            name : "z",
	            readOnly : false,
	            start : 10,
	            value : "z"
	        }
	    ]
	} 
	==Bool program(
		varDeclarations(id("x"),id("y"),id("z")),
		exp(assignment(id("x"),null,n(1))),
		exp(assignment(id("y"),null,n(2))),
		exp(assignment(id("z"),null,add(inc(id("x"),true),inc(id("y"),false)))),
		exp(assignment(id("z"),24,n(3)))) .
